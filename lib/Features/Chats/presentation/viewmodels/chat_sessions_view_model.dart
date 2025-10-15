import 'package:chat_with_charachter/Features/Chats/domain/entities/chat_session_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/usecases/get_chat_session_use_case.dart';

class ChatSessionsViewModel extends StateNotifier<AsyncValue<List<ChatSessionEntity>>>{
 final GetChatSessionsUseCase _useCase;
 ChatSessionsViewModel(this._useCase):super(AsyncLoading()){
   getChatSessions();
 }
 Future<void> getChatSessions()async{
  try{
    state=AsyncLoading();
    final sessions=await _useCase();

    state=AsyncData(sessions);
  }catch(e,st){
    state=AsyncError(e,st);
  }
 }
}