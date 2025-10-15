import '../../../../Shared/Enum/message_type.dart';

class MessageModel {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final String? username;

  MessageModel({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.username,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: json['message'] ?? '',
      type: _parseMessageType(json['type']),
      timestamp: DateTime.now(),
      username: json['username'],
    );
  }

  static MessageType _parseMessageType(String? type) {
    switch (type) {
      case 'user_message':
        return MessageType.user;
      case 'ai_message':
        return MessageType.ai;
      case 'system':
        return MessageType.system;
      case 'error':
        return MessageType.error;
      default:
        return MessageType.system;
    }
  }
}