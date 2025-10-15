


import 'package:chat_with_charachter/Features/Chats/domain/entities/message_entity.dart';

import '../../../../Shared/Enum/message_type.dart';

class StoredMessageEntity {
  final int? id;
  final int session;
  final String sender;
  final String text;
  final String? createdAt;

  StoredMessageEntity({
     this.id,
    required this.session,
    required this.sender,
    required this.text,
     this.createdAt,

  });
  MessageEntity toMessageEntity() {
    return MessageEntity(
      id: id.toString(),
      content: text,
      type: sender == 'user' ? MessageType.user : MessageType.ai,
      timestamp: createdAt != null ? DateTime.parse(createdAt!) : DateTime.now(),
      username: sender == 'user' ? 'User' : 'ai',
    );
  }
}
