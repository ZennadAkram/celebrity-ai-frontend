import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:chat_with_charachter/Features/Chats/data/repository/chat_session_repository_impl.dart';
import '../../data/datasources/chat_sessions_source.dart';
import '../../data/repository/chat_repository_impl.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/get_messages_use_case.dart';
import '../../domain/usecases/send_message_use_case.dart';
import '../viewmodels/chat_view_model.dart';

final chatViewModelProvider =
StateNotifierProvider<ChatViewModel, ChatState>((ref) {
  return ChatViewModel(
      ref.watch(sendMessageUseCaseProvider), ref,false
  );
});



final chatMessagesProvider = StreamProvider<List<MessageEntity>>((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  final chatViewModel = ref.read(chatViewModelProvider.notifier);

  return chatRepository.messages.asyncMap((messageEntity) async {
    // Add the incoming WebSocket message to ViewModel
    chatViewModel.addMessage(messageEntity);

    // Return the current state of messages
    return ref.read(chatViewModelProvider).messages;
  });
});
final messageListProvider=StateProvider<List<MessageEntity>>((ref)=>[]);
final sessionProvider=StateProvider<int>((ref)=>0);

