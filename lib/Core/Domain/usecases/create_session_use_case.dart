import 'package:chat_with_charachter/Core/Domain/repositories/create_session_repo.dart';

import '../entities/chat_session_entity.dart';

class CreateSessionUseCase{
  final CreateSessionRepository repository;
  CreateSessionUseCase(this.repository);
  Future<ChatSessionEntity> call(int celebrityId){
    return repository.createSession(celebrityId);

  }
}