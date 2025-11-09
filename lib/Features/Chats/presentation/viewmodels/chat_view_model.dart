import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:chat_with_charachter/Features/Chats/domain/entities/stored_message_entity.dart';
import 'package:flutter/foundation.dart';

import '../../../../Core/Network/providers/websocket_provider.dart';
import '../../../../Core/Network/websockets.dart';
import '../../../../Shared/Enum/message_type.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/send_message_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../providers/chat_provider.dart';
import '../providers/chat_session_provider.dart';
import '../providers/tts_providers.dart';

class ChatViewModel extends StateNotifier<ChatState> {
  final SendMessageUseCase sendMessageUseCase;
  final Ref ref;
  final bool isSpeech;
  StreamSubscription? _connectionSubscription;
  StreamSubscription? _messageSubscription;
  static List<MessageEntity> _persistentMessages = [];
  static int systemMessageCount = 0;

  // 🔥 ADD: Track current streaming message
  String? _currentStreamingMessageId;
  int _currentStreamingMessageIndex = -1;
  Timer? _streamingTimeout;
  String _currentAiFullMessage = '';



  ChatViewModel(this.sendMessageUseCase, this.ref, this.isSpeech) : super(ChatState.initial()) {
    if (_persistentMessages.isNotEmpty && state.messages.isEmpty) {
      state = state.copyWith(messages: _persistentMessages);
    }

    _initConnectionListener();
    _initMessageListener();
  }

  void _initConnectionListener() {
    final connectionStatus = ref.watch(webSocketConnectionProvider);

    _connectionSubscription = connectionStatus.when(
      data: (status) {
        state = state.copyWith(connectionStatus: status);

        if (status == ConnectionStatus.disconnected ||
            status == ConnectionStatus.error) {
          _startReconnectLoop();
        }
        return null;
      },
      loading: () {
        state = state.copyWith(connectionStatus: ConnectionStatus.connecting);
        return null;
      },
      error: (error, stack) {
        state = state.copyWith(
          connectionStatus: ConnectionStatus.error,
          error: error.toString(),
        );

        _startReconnectLoop();
        return null;
      },
    );
  }

  void _initMessageListener() {
    final webSocketService = ref.read(webSocketServiceProvider);

    _messageSubscription = webSocketService.messageStream.listen((data) {
      if (kDebugMode) {
        print('🎯 Raw WebSocket data received: $data');
      }

      try {
        // Parse the raw data into a MessageEntity
        final message = _parseWebSocketData(data);
        if(message.username=="System"){
          return;
        }
        if (kDebugMode) {
          print('🎯 Parsed message: ${message.content} (${message.type})');
        }

        // 🔥 MODIFIED: Handle AI messages with streaming
        if (message.type == MessageType.ai) {

          _handleAiMessage(message);
        } else {
          addMessage(message);
        }

        // 🔥 REMOVED: Database saving from here - handled in _stopStreamingCurrentMessage

      } catch (e) {
        if (kDebugMode) {
          print('❌ Failed to parse WebSocket data: $e');
        }
        // Create an error message entity
        final errorMessage = MessageEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: 'Failed to process message: ${e.toString()}',
          type: MessageType.error,
          timestamp: DateTime.now(),
          username: 'System',
        );
        addMessage(errorMessage);
      }
    }, onError: (error) {
      if (kDebugMode) {
        print('❌ WebSocket stream error: $error');
      }
      state = state.copyWith(error: error.toString());
    });
  }

  // 🔥 MODIFIED: Handle AI message streaming with full message tracking
  // 🔥 MODIFIED: Handle AI message streaming with full message tracking
  void _handleAiMessage(MessageEntity message) {
    final incomingMessageId = message.messageId ?? 'default_id';
    final trimmed = message.content.trim().toLowerCase();

    // 🚫 Ignore meaningless or placeholder chunks like "answer"
    if (trimmed.isEmpty || trimmed == 'answer') {
      if (kDebugMode) print('⚠️ Ignored AI placeholder chunk: "${message.content}"');
      return;
    }

    if (_currentStreamingMessageId != incomingMessageId) {
      _currentStreamingMessageId = incomingMessageId;
      _currentAiFullMessage = message.content;

      // 🔥 STOP LOADING
      state = state.copyWith(isLoading: false);

      final newMessage = message.copyWith(isStreaming: true);

        addMessage(newMessage);

      _currentStreamingMessageIndex = state.messages.length - 1;

      if (kDebugMode) {
        print('🚀 NEW AI MESSAGE STARTED: $incomingMessageId');
        print('📝 Initial content: "$_currentAiFullMessage"');
      }
    } else {
      // Append later chunks normally
      _currentAiFullMessage += message.content;
      _updateStreamingMessage(message.content);
    }

    _resetStreamingTimeout();
  }




  // 🔥 ADD: Update existing streaming message
  void _updateStreamingMessage(String newContent) {
    if (_currentStreamingMessageIndex >= 0 &&
        _currentStreamingMessageIndex < state.messages.length) {

      final currentMessage = state.messages[_currentStreamingMessageIndex];
      final updatedMessage = currentMessage.copyWith(
        content: currentMessage.content + newContent,
        isStreaming: true,
      );

      // Update the message in state
      final newMessages = List<MessageEntity>.from(state.messages);
      newMessages[_currentStreamingMessageIndex] = updatedMessage;

      state = state.copyWith(messages: newMessages);
      _persistentMessages = newMessages;

      // Update global messageListProvider
      final messageList = ref.read(messageListProvider.notifier);
      messageList.state = [...newMessages];
    }
  }

  // 🔥 MODIFIED: Stop streaming and save complete message
  // 🔥 FIXED: Stop streaming without losing messages
  Future<void> _stopStreamingCurrentMessage() async {
    if (_currentStreamingMessageIndex >= 0 &&
        _currentStreamingMessageIndex < state.messages.length) {

      final currentMessage = state.messages[_currentStreamingMessageIndex];
      final updatedMessage = currentMessage.copyWith(
        isStreaming: false,
      );

      // 🔥 FIX: Create new list and update only the streaming message
      final newMessages = List<MessageEntity>.from(state.messages);
      newMessages[_currentStreamingMessageIndex] = updatedMessage;

      // 🔥 FIX: Update state properly
      state = state.copyWith(messages: newMessages);
      _persistentMessages = newMessages;

      // 🔥 FIX: Update global messageListProvider correctly
      final messageList = ref.read(messageListProvider.notifier);
      messageList.state = List<MessageEntity>.from(newMessages); // Use copy

      // 🔥 SAVE COMPLETE MESSAGE TO DATABASE
      // 🔥 SAVE COMPLETE MESSAGE TO DATABASE OR SPEAK IT
      if (_currentAiFullMessage.isNotEmpty) {
        if (kDebugMode) {
          print('💾 Complete AI message: "$_currentAiFullMessage"');
        }

        if (isSpeech) {
          // 🎧 SPEAK ONLY THE COMPLETE MESSAGE WHEN STREAMING ENDS
          try {
            final ttsVM = ref.read(ttsViewModelProvider.notifier);

            if (kDebugMode) {
              print('🔊 Attempting to speak message (length: ${_currentAiFullMessage.length}): "${_currentAiFullMessage.trim()}"');
            }

            // 🔥 CRITICAL FIX: ADD AWAIT HERE
            await ttsVM.speak(_currentAiFullMessage.trim());

            if (kDebugMode) {
              print('🔊 Successfully spoke complete message: "${_currentAiFullMessage.trim()}"');
            }
          } catch (e) {
            print('⚠️ Error speaking complete message: $e');
          }
        }else{
          final storeMessagesVM = ref.read(storedMessagesViewModelProvider.notifier);
          final sessionId = ref.read(sessionProvider);
          storeMessagesVM.saveMessage(
              StoredMessageEntity(
                  session: sessionId,
                  sender: 'ai',
                  text: _currentAiFullMessage
              )
          );
        }
      }
    }


    // 🔥 RESET tracking variables
    _currentStreamingMessageId = null;
    _currentStreamingMessageIndex = -1;
    _currentAiFullMessage = '';
    _cancelStreamingTimeout();


    if (kDebugMode) {
      print('✅ Streaming stopped. Total messages: ${state.messages.length}');
      for (var msg in state.messages) {
        print('   - "${msg.content}" (${msg.type})');
      }
    }
  }

  // 🔥 ADD: Streaming timeout methods
  void _resetStreamingTimeout() {
    _cancelStreamingTimeout();
    _streamingTimeout = Timer(const Duration(seconds: 5), () {
      if (_currentStreamingMessageId != null) {
        if (kDebugMode) {
          print('⏰ Streaming timeout - assuming message ended');
        }
        state = state.copyWith(isLoading: false);
        _stopStreamingCurrentMessage();

      }
    });
  }

  void _cancelStreamingTimeout() {
    _streamingTimeout?.cancel();
    _streamingTimeout = null;
  }

  Timer? _reconnectTimer;

  void _startReconnectLoop() {
    _reconnectTimer?.cancel(); // avoid multiple timers

    _reconnectTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (state.connectionStatus != ConnectionStatus.connected) {
        if (kDebugMode) print("🔄 Trying to reconnect WebSocket...");
        state = state.copyWith(connectionStatus: ConnectionStatus.connecting);
        ref.read(webSocketServiceProvider).connect(); // your reconnect logic
      } else {
        timer.cancel(); // stop once connected
      }
    });
  }

  // 🔥 MODIFIED: Handle message_id and ai_message_done
  // 🔥 FIXED: Handle message_id and ai_message_done
  // 🔥 ALTERNATIVE FIX: Return a special marker
  MessageEntity _parseWebSocketData(dynamic data) {
    Map<String, dynamic> jsonData;

    if (data is Map<String, dynamic>) {
      jsonData = data;
    } else if (data is String) {
      jsonData = json.decode(data);
    } else {
      throw FormatException('Unknown WebSocket data format: ${data.runtimeType}');
    }

    // Check if this is ai_message_done to stop streaming
    if (jsonData['type'] == 'ai_message_done') {
      _stopStreamingCurrentMessage();
      // 🔥 FIX: Return a special marker that will be ignored
      return MessageEntity(
        id: 'streaming_complete_marker',
        content: '',
        type: MessageType.system,
        timestamp: DateTime.now(),
        username: 'System',
        isStreaming: false,
      );
    }

    // Regular message parsing
    return MessageEntity(
      id: jsonData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: jsonData['message'] ?? '',
      type: _parseMessageType(jsonData['type']),
      timestamp: DateTime.now(),
      username: jsonData['username'],
      messageId: jsonData['message_id'],
      isStreaming: jsonData['type'] == 'ai_message',
    );
  }

  MessageType _parseMessageType(dynamic type) {
    if (type == null) return MessageType.system;

    final typeString = type.toString().toLowerCase();
    if (typeString.contains('user')) return MessageType.user;
    if (typeString.contains('ai')) return MessageType.ai;
    if (typeString.contains('system')) return MessageType.system;
    if (typeString.contains('error')) return MessageType.error;

    return MessageType.system;
  }

  Future<void> sendMessage(String message, int celebrityId) async {
    if (message.trim().isEmpty) return;
    if (state.connectionStatus != ConnectionStatus.connected) {
      if (kDebugMode) {
        print('❌ Cannot send message - not connected');
      }
      return;
    }

    if (kDebugMode) {
      print('📤 Sending message: $message');
    }

    // Add user message immediately (local echo)
    addMessage(MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message,
      type: MessageType.user,
      timestamp: DateTime.now(),
      username: 'User',
    ));

    // 🔥 SET LOADING: Show loading indicator while waiting for AI response
    state = state.copyWith(isLoading: true);

    // Send to server
    try {
      await sendMessageUseCase.execute(message, celebrityId);
      // 🔥 DON'T set isLoading to false here - wait for first AI message
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error sending message: $e');
      }
      // 🔥 SET LOADING FALSE on error
      state = state.copyWith(isLoading: false);
    }
  }
  void addMessage(MessageEntity message) {
    if (kDebugMode) {
      print('📥 Adding message to state: ${message.content}');
    }

    // ✅ Always start from the global provider (it holds the history)
    final currentMessages = ref.read(messageListProvider);

    final updatedMessages = [...currentMessages, message];
    _persistentMessages = updatedMessages;

    // Update local ChatState and global messageListProvider consistently
    state = state.copyWith(messages: updatedMessages);

    final messageList = ref.read(messageListProvider.notifier);
    messageList.state = updatedMessages;

    if (kDebugMode) {
      print('✅ messageListProvider updated (${updatedMessages.length} messages)');
    }
  }


  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _connectionSubscription?.cancel();
    _messageSubscription?.cancel();
    _reconnectTimer?.cancel();
    _streamingTimeout?.cancel();
    super.dispose();
  }
}

class ChatState {
  final List<MessageEntity> messages;
  final bool isLoading;
  final ConnectionStatus connectionStatus;
  final String? error;

  ChatState({
    required this.messages,
    required this.isLoading,
    required this.connectionStatus,
    this.error,
  });

  factory ChatState.initial() => ChatState(
    messages: [],
    isLoading: false,
    connectionStatus: ConnectionStatus.disconnected,
    error: null,
  );

  ChatState copyWith({
    List<MessageEntity>? messages,
    bool? isLoading,
    ConnectionStatus? connectionStatus,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      error: error ?? this.error,
    );
  }
}