import 'dart:async';
import 'dart:convert';
import 'package:chat_with_charachter/Core/Network/secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum ConnectionStatus { connected, connecting, disconnected, error, unauthorized }

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<dynamic> _messageController = StreamController<dynamic>.broadcast();
  final StreamController<ConnectionStatus> _statusController = StreamController<ConnectionStatus>.broadcast();
  ConnectionStatus _status = ConnectionStatus.disconnected;
  Timer? _reconnectTimer;
  String? _currentUrl;

  // 🔥 ADDED: Same message tracking
  String? _currentMessageId;
  bool _isStreaming = false;
  Timer? _streamingTimeout;

  Stream<dynamic> get messageStream => _messageController.stream;
  Stream<ConnectionStatus> get statusStream => _statusController.stream;
  ConnectionStatus get status => _status;

  Future<void> connect() async {
    try {
      _updateStatus(ConnectionStatus.connecting);
      if (kDebugMode) {
        print('🔄 Connecting to WebSocket...');
      }

      final token = await TokenStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        _updateStatus(ConnectionStatus.unauthorized);
        if (kDebugMode) {
          print('❌ No authentication token available');
        }
        throw Exception('No authentication token available');
      }

      if (kDebugMode) {
        print('🔑 Token found: ${token.substring(0, 20)}...');
      }

      final baseSocket = dotenv.env['BASE_SOCKET'];
      if (baseSocket == null) {
        throw Exception('BASE_SOCKET not set');
      }
      final url = '$baseSocket?token=$token';

      if (kDebugMode) {
        print('🌐 Connecting to: $url');
      }

      _channel = WebSocketChannel.connect(
        Uri.parse(url),
        protocols: ['chat'],
      );

      if (kDebugMode) {
        print('✅ WebSocket channel created');
      }

      _channel!.stream.listen(
            (data) {
          if (kDebugMode) {
            print('📨 Received data: $data');
          }
          _handleIncomingMessage(data);
        },
        onError: (error) {
          if (kDebugMode) {
            print('❌ WebSocket error: $error');
          }
          _handleWebSocketError(error);
        },
        onDone: () {
          if (kDebugMode) {
            print('✅ WebSocket connection closed');
          }
          _handleWebSocketDisconnect();
        },
      );

      _updateStatus(ConnectionStatus.connected);
      if (kDebugMode) {
        print('🎉 WebSocket connected successfully!');
      }

    } catch (e) {
      if (kDebugMode) {
        print('💥 WebSocket connection failed: $e');
        print('💥 Error type: ${e.runtimeType}');
      }
      _updateStatus(ConnectionStatus.error);
      _scheduleReconnect();
      rethrow;
    }
  }

  void _handleIncomingMessage(dynamic data) {
    try {
      final decodedData = json.decode(data);

      // 🔥 ADDED: Same message tracking logic
      if (decodedData['type'] == 'ai_message') {
        // Check if this is a new message or same message
        final messageId = decodedData['message_id'] ?? 'default_id';

        if (!_isStreaming || _currentMessageId != messageId) {
          // New message starting
          _currentMessageId = messageId;
          _isStreaming = true;
          if (kDebugMode) {
            print('🚀 NEW MESSAGE STARTED: $messageId');
          }
        }

        // Reset timeout for same message
        _resetStreamingTimeout();

      } else if (decodedData['type'] == 'ai_message_done') {
        // Message finished
        _isStreaming = false;
        _currentMessageId = null;
        _cancelStreamingTimeout();
        if (kDebugMode) {
          print('✅ MESSAGE COMPLETED');
        }
      }

      _messageController.add(decodedData);
    } catch (e) {
      _messageController.add({'type': 'text', 'message': data});
    }
  }

  void _handleWebSocketError(dynamic error) {
    _updateStatus(ConnectionStatus.error);
    _messageController.addError(error);
    _scheduleReconnect();
  }

  void _handleWebSocketDisconnect() {
    _updateStatus(ConnectionStatus.disconnected);
    _scheduleReconnect();
  }

  void sendMessage(String message, int celebrityId) {
    if (_channel != null && _status == ConnectionStatus.connected) {
      final messageData = {
        'message': message,
        'celebrity_id': celebrityId,
      };
      _channel!.sink.add(json.encode(messageData));

      if (kDebugMode) {
        print('📤 Sent message: $messageData');
      }
    } else {
      if (kDebugMode) {
        print('⚠️ Tried to send while disconnected');
      }
    }
  }

  void sendJson(Map<String, dynamic> data) {
    if (_channel != null && _status == ConnectionStatus.connected) {
      _channel!.sink.add(json.encode(data));
    }
  }

  Future<void> disconnect() async {
    _cancelReconnectTimer();
    await _channel?.sink.close();
    _updateStatus(ConnectionStatus.disconnected);
  }

  void _updateStatus(ConnectionStatus newStatus) {
    _status = newStatus;
    _statusController.add(newStatus);
  }

  void _scheduleReconnect() {
    _cancelReconnectTimer();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (_status != ConnectionStatus.connected && _currentUrl != null) {
        connect();
      }
    });
  }

  void _cancelReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  // 🔥 ADDED: Streaming timeout methods
  void _resetStreamingTimeout() {
    _cancelStreamingTimeout();
    _streamingTimeout = Timer(const Duration(seconds: 5), () {
      if (_isStreaming) {
        if (kDebugMode) {
          print('⏰ Streaming timeout - assuming message ended');
        }
        _isStreaming = false;
        _currentMessageId = null;
      }
    });
  }

  void _cancelStreamingTimeout() {
    _streamingTimeout?.cancel();
    _streamingTimeout = null;
  }

  void dispose() {
    _cancelReconnectTimer();
    _channel?.sink.close();
    _messageController.close();
    _statusController.close();
  }
}