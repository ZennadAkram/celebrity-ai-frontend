
import '../../../../Shared/Enum/message_type.dart';

class MessageEntity {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final String? username;
  final bool isStreaming; // 🔥 ADD THIS
  final String? messageId; // 🔥 ADD THIS for tracking same message

  MessageEntity({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.username,
    this.isStreaming = false, // 🔥 ADD THIS
    this.messageId, // 🔥 ADD THIS
  });

  // Add copyWith method if you don't have it
  MessageEntity copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    String? username,
    bool? isStreaming,
    String? messageId,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      username: username ?? this.username,
      isStreaming: isStreaming ?? this.isStreaming,
      messageId: messageId ?? this.messageId,
    );
  }
}