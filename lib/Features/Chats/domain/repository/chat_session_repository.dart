import 'package:chat_with_charachter/Features/Chats/domain/entities/chat_session_entity.dart';
import 'package:chat_with_charachter/Features/Chats/domain/entities/stored_message_entity.dart';



abstract class ChatSessionRepository{
  Future<List<ChatSessionEntity>> getChatSessions();
  Future<List<StoredMessageEntity>> getMessagesForSession(int sessionId);
  Future<void> saveMessage(StoredMessageEntity message);


}