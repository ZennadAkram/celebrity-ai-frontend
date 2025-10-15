import '../entities/message_entity.dart';

abstract class ChatRepository{
  Stream<MessageEntity> get messages;
  Future<void> connect();
  Future<void> disconnect();
  Future<void> sendMessage(String message,int celebrityId);
}