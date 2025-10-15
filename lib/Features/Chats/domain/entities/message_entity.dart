import '../../../../Shared/Enum/message_type.dart';

class MessageEntity {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final String? username;

  MessageEntity({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.username,
  });
}