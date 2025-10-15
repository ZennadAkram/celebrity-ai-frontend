import 'package:chat_with_charachter/Features/Chats/domain/entities/stored_message_entity.dart';
import 'package:chat_with_charachter/Features/Chats/domain/repository/chat_session_repository.dart';

class SaveMessageUseCase{
  final ChatSessionRepository repository;
  SaveMessageUseCase(this.repository);
  Future<void> call(StoredMessageEntity entity) async {
    repository.saveMessage(entity);
  }

}