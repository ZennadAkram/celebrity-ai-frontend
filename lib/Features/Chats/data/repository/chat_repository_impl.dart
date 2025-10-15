import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Core/Network/providers/websocket_provider.dart';
import '../../../../Core/Network/websockets.dart';
import '../../../../Shared/Enum/message_type.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repository/chat_repository.dart';
import '../models/message_model.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final webSocketService = ref.watch(webSocketServiceProvider);
  return ChatRepositoryImpl(webSocketService: webSocketService);
});

class ChatRepositoryImpl implements ChatRepository {
  final WebSocketService webSocketService;

  ChatRepositoryImpl({required this.webSocketService});

  @override
  Stream<MessageEntity> get messages => webSocketService.messageStream
      .where((data) => data is Map<String, dynamic>)
      .map((data) => _mapModelToEntity(MessageModel.fromJson(data)));

  // Convert Data Layer Model to Domain Layer Entity
  MessageEntity _mapModelToEntity(MessageModel model) {
    return MessageEntity(
      id: model.id,
      content: model.content,
      type: _convertMessageType(model.type),
      timestamp: model.timestamp,
      username: model.username,
    );
  }

  // Convert data layer MessageType to domain layer MessageType
  MessageType _convertMessageType(dynamic modelType) {
    if (modelType.toString().contains('user')) return MessageType.user;
    if (modelType.toString().contains('ai')) return MessageType.ai;
    if (modelType.toString().contains('system')) return MessageType.system;
    if (modelType.toString().contains('error')) return MessageType.error;
    return MessageType.system;
  }

  @override
  Future<void> connect() async {
    await webSocketService.connect();
  }

  @override
  Future<void> disconnect() async {
    await webSocketService.disconnect();
  }

  @override
  Future<void> sendMessage(String message,int celebrityId) async {
    webSocketService.sendMessage(message,celebrityId);
  }
}