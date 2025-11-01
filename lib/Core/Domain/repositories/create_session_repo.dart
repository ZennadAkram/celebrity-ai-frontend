import 'package:chat_with_charachter/Core/Domain/entities/chat_session_entity.dart';

abstract class CreateSessionRepository{
  Future<ChatSessionEntity> createSession(int celebrityId);
}