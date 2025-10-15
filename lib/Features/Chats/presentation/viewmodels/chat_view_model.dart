import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Core/Network/providers/websocket_provider.dart';
import '../../../../Core/Network/websockets.dart';
import '../../../../Shared/Enum/message_type.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/send_message_use_case.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../providers/chat_session_provider.dart';

class ChatViewModel extends StateNotifier<ChatState> {
  final SendMessageUseCase sendMessageUseCase;
  final Ref ref;
  StreamSubscription? _connectionSubscription;
  StreamSubscription? _messageSubscription;
  Timer? _reconnectTimer;

  List<MessageEntity> _persistentMessages = [];
  int _systemMessageCount = 0;
  bool _areStoredMessagesLoaded = false;
  final List<MessageEntity> _pendingMessages = [];

  // Instance tracking
  static int _instanceCounter = 0;
  final int _instanceId;

  ChatViewModel(this.sendMessageUseCase, this.ref)
      : _instanceId = ++_instanceCounter,
        super(ChatState.initial()) {
    if (kDebugMode) {
      print('🔄 ChatViewModel instance CREATED: $_instanceId, Hash: ${identityHashCode(this)}');
    }
    _initializeViewModel();
  }

  void _initializeViewModel() {
    if (kDebugMode) {
      print("🔄 Initializing ChatViewModel Instance: $_instanceId");
      print("📊 Persistent messages count: ${_persistentMessages.length}");
      print("📊 State messages count: ${state.messages.length}");
    }

    if (_persistentMessages.isNotEmpty && state.messages.isEmpty) {
      if (kDebugMode) print("🔄 Restoring persistent messages to state");
      _safeSetState((state) => state.copyWith(messages: _persistentMessages));
    }

    _initConnectionListener();
    _initMessageListener();
  }

  void _safeSetState(ChatState Function(ChatState) update) {
    try {
      final oldState = state;
      final newState = update(state);

      if (oldState.messages.length != newState.messages.length) {
        if (kDebugMode) {
          print('🔄 STATE CHANGED - Instance: $_instanceId, Messages: ${oldState.messages.length} → ${newState.messages.length}');
        }
      }

      state = newState;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating state in instance $_instanceId: $e');
      }
    }
  }

  void _initConnectionListener() {
    final connectionStatus = ref.watch(webSocketConnectionProvider);

    _connectionSubscription?.cancel();
    _connectionSubscription = connectionStatus.when(
      data: (status) {
        _safeSetState((state) => state.copyWith(connectionStatus: status));
        if (status == ConnectionStatus.connected) {
          // Reset the loaded flag when reconnecting
          _areStoredMessagesLoaded = false;
          _pendingMessages.clear();
        } else if (status == ConnectionStatus.disconnected ||
            status == ConnectionStatus.error) {
          _startReconnectLoop();
        }
        return null;
      },
      loading: () {
        _safeSetState((state) =>
            state.copyWith(connectionStatus: ConnectionStatus.connecting));
        return null;
      },
      error: (error, stack) {
        _safeSetState((state) => state.copyWith(
          connectionStatus: ConnectionStatus.error,
          error: error.toString(),
        ));
        _startReconnectLoop();
        return null;
      },
    );
  }

  void _initMessageListener() {
    final webSocketService = ref.read(webSocketServiceProvider);

    _messageSubscription?.cancel();
    _messageSubscription = webSocketService.messageStream.listen(
          (data) {
        if (kDebugMode) {
          print('🎯 Raw WebSocket data received in instance $_instanceId: $data');
        }

        // Quick filter for obvious duplicates before parsing
        if (_isLikelyDuplicate(data)) {
          if (kDebugMode) print('🚫 Filtering likely duplicate before parsing in instance $_instanceId');
          return;
        }

        try {
          final message = _parseWebSocketData(data);
          if (kDebugMode) {
            print('🎯 Parsed message in instance $_instanceId: ${message.content} (${message.type})');
          }

          // If stored messages aren't loaded yet, queue the message
          if (!_areStoredMessagesLoaded) {
            if (kDebugMode) print('⏳ Queueing message in instance $_instanceId until stored messages are loaded');
            _pendingMessages.add(message);
            return;
          }

          _processIncomingMessage(message);
        } catch (e) {
          if (kDebugMode) {
            print('❌ Failed to parse WebSocket data in instance $_instanceId: $e');
          }
          addMessage(MessageEntity(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content: 'Failed to process message: ${e.toString()}',
            type: MessageType.error,
            timestamp: DateTime.now(),
            username: 'System',
          ));
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('❌ WebSocket stream error in instance $_instanceId: $error');
        }
        _safeSetState((state) => state.copyWith(error: error.toString()));
      },
    );
  }

  bool _isLikelyDuplicate(dynamic data) {
    // Quick check for welcome message duplicates before parsing
    if (data is String && data.contains('Welcome') && data.contains('system')) {
      return _pendingMessages.length > 2; // If we already have multiple pending, skip
    }
    return false;
  }

  void _debugState() {
    if (kDebugMode) {
      print('🔍 DEBUG STATE Instance $_instanceId:');
      print('📊 State messages count: ${state.messages.length}');
      print('📊 Persistent messages count: ${_persistentMessages.length}');
      print('📝 Messages:');
      for (var i = 0; i < state.messages.length; i++) {
        final msg = state.messages[i];
        print('  $i: ${msg.content} (${msg.type})');
      }
    }
  }

  void _processIncomingMessage(MessageEntity message) {
    // More aggressive duplicate detection for system messages
    if (message.type == MessageType.system) {
      // Check if we already have ANY system message with similar content
      final hasSimilarSystemMessage = _persistentMessages.any((m) =>
      m.type == MessageType.system &&
          m.content.toLowerCase().contains('welcome'));

      if (hasSimilarSystemMessage) {
        if (kDebugMode) print('⏩ Skipping duplicate system welcome message in instance $_instanceId');
        return;
      }

      // Also check current state for duplicates
      final hasSimilarInCurrentState = state.messages.any((m) =>
      m.type == MessageType.system &&
          m.content.toLowerCase().contains('welcome'));

      if (hasSimilarInCurrentState) {
        if (kDebugMode) print('⏩ Skipping duplicate system message in current state in instance $_instanceId');
        return;
      }
    }

    addMessage(message);
  }

  void _processPendingMessages() {
    if (kDebugMode) print('🔄 Processing ${_pendingMessages.length} pending messages in instance $_instanceId');

    for (final message in _pendingMessages) {
      _processIncomingMessage(message);
    }
    _pendingMessages.clear();
  }

  void _startReconnectLoop() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (state.connectionStatus != ConnectionStatus.connected) {
        if (kDebugMode) print("🔄 Trying to reconnect WebSocket in instance $_instanceId...");
        _safeSetState((state) =>
            state.copyWith(connectionStatus: ConnectionStatus.connecting));
        ref.read(webSocketServiceProvider).connect();
      } else {
        timer.cancel();
      }
    });
  }

  MessageEntity _parseWebSocketData(dynamic data) {
    final Map<String, dynamic> jsonData;
    if (data is Map<String, dynamic>) {
      jsonData = data;
    } else if (data is String) {
      jsonData = json.decode(data);
    } else {
      throw FormatException('Unknown WebSocket data format: ${data.runtimeType}');
    }

    return MessageEntity(
      id: jsonData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: jsonData['message'] ?? '',
      type: _parseMessageType(jsonData['type']),
      timestamp: DateTime.now(),
      username: jsonData['username'],
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
      if (kDebugMode) print('❌ Cannot send message - not connected in instance $_instanceId');
      return;
    }

    if (kDebugMode) print('📤 Sending message from instance $_instanceId: $message');

    addMessage(MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message,
      type: MessageType.user,
      timestamp: DateTime.now(),
      username: 'User',
    ));

    _safeSetState((state) => state.copyWith(isLoading: true));

    try {
      await sendMessageUseCase.execute(message, celebrityId);
    } catch (e) {
      if (kDebugMode) print('❌ Error sending message from instance $_instanceId: $e');
      _safeSetState((state) => state.copyWith(isLoading: false));
    }
  }

  void addMessage(MessageEntity message) {
    if (kDebugMode) print('📥 Adding message to state: ${message.content}');

    // Improved duplicate detection
    final isDuplicate = _persistentMessages.any((m) =>
    m.id == message.id || ( // Check by ID first
        m.content == message.content &&
            m.type == message.type &&
            DateTime.now().difference(m.timestamp).inSeconds < 2
    )
    );

    if (isDuplicate) {
      if (kDebugMode) print('⏩ Skipping duplicate message: ${message.content}');
      return;
    }

    _safeSetState((currentState) {
      final newMessages = [...currentState.messages, message];
      _persistentMessages = newMessages;

      if (message.type == MessageType.ai) {
        return currentState.copyWith(
          messages: newMessages,
          isLoading: false,
        );
      }

      return currentState.copyWith(messages: newMessages);
    });
  }

  Future<void> loadStoredMessages(int sessionId) async {
    if (kDebugMode) print("🔄 Loading stored messages in instance $_instanceId for session: $sessionId");

    try {
      final storedMessagesVM = ref.read(storedMessagesViewModelProvider.notifier);
      final stored = await storedMessagesVM.getMessages(sessionId);

      if (stored.isEmpty) {
        if (kDebugMode) print("ℹ️ No stored messages found for instance $_instanceId");
        _areStoredMessagesLoaded = true;
        _processPendingMessages();
        return;
      }

      final oldMessages = stored.map((m) => m.toMessageEntity()).toList();

      if (kDebugMode) print("📨 Found ${oldMessages.length} stored messages for instance $_instanceId");

      // Use the same pattern as addMessage to ensure consistency
      _safeSetState((currentState) {
        _persistentMessages = [...oldMessages];
        return currentState.copyWith(
          messages: oldMessages,
          isLoading: false,
        );
      });

      if (kDebugMode) print("✅ Loaded ${oldMessages.length} old messages in instance $_instanceId");
      _debugState();

      // Mark as loaded and process any pending WebSocket messages
      _areStoredMessagesLoaded = true;
      _processPendingMessages();

    } catch (e) {
      if (kDebugMode) print("❌ Error loading stored messages in instance $_instanceId: $e");
      _areStoredMessagesLoaded = true;
      _processPendingMessages();
    }
  }

  void clearMessages() {
    _persistentMessages = [];
    _systemMessageCount = 0;
    _areStoredMessagesLoaded = false;
    _pendingMessages.clear();
    _safeSetState((state) => state.copyWith(messages: []));
  }

  void clearError() {
    _safeSetState((state) => state.copyWith(error: null));
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print('🗑️ ChatViewModel instance DISPOSED: $_instanceId, Hash: ${identityHashCode(this)}');
    }
    _connectionSubscription?.cancel();
    _messageSubscription?.cancel();
    _reconnectTimer?.cancel();
    debugPrint("🔒 Preventing ChatViewModel disposal");
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