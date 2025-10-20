import 'package:chat_with_charachter/Features/Chats/domain/entities/message_entity.dart';
import 'package:chat_with_charachter/Features/Chats/domain/entities/stored_message_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../Shared/Enum/message_type.dart';
import '../../domain/usecases/get_messages_use_case.dart';
import '../../domain/usecases/save_message_use_case.dart';

class StoredMessageViewModel extends StateNotifier<AsyncValue<List<StoredMessageEntity>>>{
  final GetMessagesUseCase _getMessagesUseCase;
  final SaveMessageUseCase _saveMessageUseCase;
  StoredMessageViewModel(this._getMessagesUseCase, this._saveMessageUseCase):super(const AsyncLoading());
  Future<List<StoredMessageEntity>> getMessages(int sessionId)async{
    try{
      state=const AsyncLoading();
      final messages=await _getMessagesUseCase(sessionId);
      state=AsyncData(messages.reversed.toList());
      return messages;
    }catch(e,st){
      state=AsyncError(e,st);
      return [];
    }
  }

  List<MessageEntity> toMessageEntity(){
    if(state.value==null){
      return [];
    }
    return state.value!.map((e) => MessageEntity(
      id: e.id.toString(),
      content:e.text ,
      timestamp:DateTime.parse(e.createdAt ?? ""),
      type: e.sender.contains('user')?MessageType.user:MessageType.ai,

    )).toList();

  }
  Future<void> saveMessage(StoredMessageEntity entity)async{
    await _saveMessageUseCase(entity);
  }

}
