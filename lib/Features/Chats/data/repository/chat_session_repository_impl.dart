import 'package:chat_with_charachter/Features/Chats/domain/entities/chat_session_entity.dart';
import 'package:chat_with_charachter/Features/Chats/domain/entities/stored_message_entity.dart';

import '../../domain/repository/chat_session_repository.dart';
import '../datasources/chat_sessions_source.dart';
import '../models/stored_message_model.dart';

class ChatSessionRepositoryImpl implements ChatSessionRepository {
  final ChatSessionsSource remoteDataSource;

  ChatSessionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ChatSessionEntity>> getChatSessions() async {
    final model= await remoteDataSource.getChatSessions();
    return model.map((e)=>e.toEntity()).toList();
  }

  @override
  Future<List<StoredMessageEntity>> getMessagesForSession(int sessionId) async{
    final model=await remoteDataSource.getMessagesForSession(sessionId);
    return model.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> saveMessage(StoredMessageEntity message) {
    final model=StoredMessageModel.fromEntity(message);
    return remoteDataSource.saveMessage(model);
  }


}