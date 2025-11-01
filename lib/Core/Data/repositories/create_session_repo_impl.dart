import 'package:chat_with_charachter/Core/Domain/entities/chat_session_entity.dart';

import '../../Domain/repositories/create_session_repo.dart';
import '../datasources/create_session_data_source.dart';

class CreateSessionRepositoryImpl implements CreateSessionRepository{
  final ChatSessionsSources _source;
  CreateSessionRepositoryImpl(this._source);
  @override
  Future<ChatSessionEntity> createSession(int celebrityId) async{
   final model=await _source.createChatSessions(celebrityId);
   return model.toEntity();
  
  }

}