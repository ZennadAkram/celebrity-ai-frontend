import 'package:chat_with_charachter/Core/Domain/entities/chat_session_entity.dart';
import 'package:chat_with_charachter/Features/Chats/domain/entities/stored_message_entity.dart';



abstract class ChatSessionRepository{
  Future<List<ChatSessionEntity>> getChatSessions(int? page);
  Future<List<StoredMessageEntity>> getMessagesForSession(int sessionId,{int? page});
  Future<void> saveMessage(StoredMessageEntity message);


}