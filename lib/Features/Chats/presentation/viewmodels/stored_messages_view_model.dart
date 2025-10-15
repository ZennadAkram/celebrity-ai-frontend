import 'package:chat_with_charachter/Features/Chats/domain/entities/stored_message_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/usecases/get_messages_use_case.dart';

class StoredMessageViewModel extends StateNotifier<AsyncValue<List<StoredMessageEntity>>>{
  final GetMessagesUseCase _getMessagesUseCase;
  StoredMessageViewModel(this._getMessagesUseCase):super(const AsyncLoading());
  Future<List<StoredMessageEntity>> getMessages(int sessionId)async{
    try{
      state=const AsyncLoading();
      final messages=await _getMessagesUseCase(sessionId);
      state=AsyncData(messages);
      return messages;
    }catch(e,st){
      state=AsyncError(e,st);
      return [];
    }
  }
}
