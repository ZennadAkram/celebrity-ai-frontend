import 'dart:async';
import 'dart:convert';

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
class ChatViewModel extends StateNotifier<ChatState> {
  final SendMessageUseCase sendMessageUseCase;
  final Ref ref;
  StreamSubscription? _connectionSubscription;
  StreamSubscription? _messageSubscription;
  static List<MessageEntity> _persistentMessages = [];
  static int systemMessageCount = 0;

  ChatViewModel(this.sendMessageUseCase, this.ref) : super(ChatState.initial()) {
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

        if (kDebugMode) {
          print('🎯 Parsed message: ${message.content} (${message.type})');
        }

        addMessage(message);
       if(message.type!=MessageType.system){
         final storeMessagesVM = ref.read(storedMessagesViewModelProvider.notifier);
         final sessionId = ref.read(sessionProvider);
         storeMessagesVM.saveMessage(
             StoredMessageEntity(session: sessionId, sender:'ai'  , text: message.content)
         );
       }
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

  MessageEntity _parseWebSocketData(dynamic data) {
    if (data is Map<String, dynamic>) {
      // Already parsed JSON
      return MessageEntity(
        id: data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        content: data['message'] ?? '',
        type: _parseMessageType(data['type']),
        timestamp: DateTime.now(),
        username: data['username'],
      );
    } else if (data is String) {
      // String data, try to parse as JSON
      final jsonData = json.decode(data);
      return MessageEntity(
        id: jsonData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        content: jsonData['message'] ?? '',
        type: _parseMessageType(jsonData['type']),
        timestamp: DateTime.now(),
        username: jsonData['username'],
      );
    } else {
      throw FormatException('Unknown WebSocket data format: ${data.runtimeType}');
    }
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

  Future<void> sendMessage(String message,int celebrityId) async {
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



    state = state.copyWith(isLoading: true);
    // Send to server
    try {
      await sendMessageUseCase.execute(message,celebrityId);

      addMessage(MessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: message,
        type: MessageType.user,
        timestamp: DateTime.now(),
        username: 'User',
      ));
      state = state.copyWith(isLoading: true);

    } catch (e) {
      if (kDebugMode) {
        print('❌ Error sending message: $e');
      }
      state = state.copyWith(isLoading: false);
    }
  }

  void addMessage(MessageEntity message) {
    if (kDebugMode) {
      print('📥 Adding message to state: ${message.content}');
    }

    final newMessages = [...state.messages, message];
    _persistentMessages = newMessages;


      state = state.copyWith(messages: newMessages, isLoading: false);

    // 🧠 NEW: Update global messageListProvider
    final messageList = ref.read(messageListProvider.notifier);
    messageList.state = [...messageList.state, message];

  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _connectionSubscription?.cancel();
    _messageSubscription?.cancel();
    _reconnectTimer?.cancel();
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
    messages: [] ,
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