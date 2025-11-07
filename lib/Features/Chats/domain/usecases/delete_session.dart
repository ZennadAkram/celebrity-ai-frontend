import '../repository/chat_session_repository.dart';

class DeleteSessionUseCase{
  final ChatSessionRepository repository;
  DeleteSessionUseCase(this.repository);
  Future<void> call(int id)async{
    await repository.deleteSession(id);
  }

}