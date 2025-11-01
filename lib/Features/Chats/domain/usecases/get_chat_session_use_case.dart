import 'package:chat_with_charachter/Core/Domain/entities/chat_session_entity.dart';

import '../repository/chat_session_repository.dart';

class GetChatSessionsUseCase{
  final ChatSessionRepository repository;
  GetChatSessionsUseCase(this.repository);
  Future<List<ChatSessionEntity>> call(int? page){
    return repository.getChatSessions(page);
  }
}