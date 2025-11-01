import 'package:chat_with_charachter/Features/Chats/domain/entities/stored_message_entity.dart';
import 'package:chat_with_charachter/Features/Chats/domain/repository/chat_session_repository.dart';

class GetMessagesUseCase{
  final ChatSessionRepository repository;
  GetMessagesUseCase(this.repository);
  Future<List<StoredMessageEntity>> call(int sessionId,{int? page}){
    return repository.getMessagesForSession(sessionId,page: page);
  }
}
