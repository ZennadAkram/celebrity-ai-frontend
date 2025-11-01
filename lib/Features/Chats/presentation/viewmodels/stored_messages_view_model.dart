import 'package:chat_with_charachter/Features/Chats/domain/entities/message_entity.dart';
import 'package:chat_with_charachter/Features/Chats/domain/entities/stored_message_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../Shared/Enum/message_type.dart';
import '../../domain/usecases/get_messages_use_case.dart';
import '../../domain/usecases/save_message_use_case.dart';

class StoredMessageViewModel extends StateNotifier<AsyncValue<List<StoredMessageEntity>>>{
  final GetMessagesUseCase _getMessagesUseCase;
  final SaveMessageUseCase _saveMessageUseCase;
  StoredMessageViewModel(this._getMessagesUseCase, this._saveMessageUseCase):super(const AsyncLoading());
 int _currentPage=1;
  Future<void> getMessages(int sessionId)async{
    hasMoreMessages=true;
    try{
      state=const AsyncLoading();
      final messages=await _getMessagesUseCase(sessionId,page: 1);
      state=AsyncData(messages.reversed.toList());
      if(messages.length <15){
        hasMoreMessages=false;
      }
      if(messages.isEmpty){
        hasMoreMessages=false;
      }
      _currentPage=2;

    }catch(e,st){
      state=AsyncError(e,st);
      if(kDebugMode){
        print(e);
        print(st);
      }
    }
  }
  bool hasMoreMessages=true;
  Future<void> loadMoreMessages(int sessionId)async{
    if(!hasMoreMessages){
      return;
    }
    try{
      final currentMessages=state.value?.reversed.toList();

      final messages=await _getMessagesUseCase(sessionId,page: _currentPage);

      state=AsyncData([...currentMessages!,...messages].reversed.toList());
      if(messages.isEmpty){
        hasMoreMessages=false;
      }
      if(messages.length <15){
        hasMoreMessages=false;
      }
      _currentPage++;

    }catch(e,st){
      state=AsyncError(e,st);
      if(kDebugMode){
        print(e);
        print(st);
      }
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
