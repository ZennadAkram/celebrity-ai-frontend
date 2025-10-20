import 'package:chat_with_charachter/Features/Chats/data/repository/chat_session_repository_impl.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/chat_sessions_source.dart';
import '../../domain/entities/chat_session_entity.dart';
import '../../domain/entities/stored_message_entity.dart';
import '../../domain/usecases/get_chat_session_use_case.dart';
import '../../domain/usecases/get_messages_use_case.dart';
import '../../domain/usecases/save_message_use_case.dart';
import '../viewmodels/chat_sessions_view_model.dart';
import '../viewmodels/stored_messages_view_model.dart';
final repositoryProvider = Provider<ChatSessionRepositoryImpl>((ref) {
  return ChatSessionRepositoryImpl( remoteDataSource:ChatSessionsSource());
});
final getMessagesUseCaseProvider = Provider<GetMessagesUseCase>((ref) {
  final chatRepository = ref.watch(repositoryProvider);
  return GetMessagesUseCase(chatRepository);

});
final saveMessageUseCaseProvider=Provider<SaveMessageUseCase>((ref){
  return SaveMessageUseCase(ref.watch(repositoryProvider));
});

final storedMessagesViewModelProvider=StateNotifierProvider<StoredMessageViewModel,AsyncValue<List<StoredMessageEntity>>>((ref){
  return StoredMessageViewModel(ref.watch(getMessagesUseCaseProvider),
  ref.watch(saveMessageUseCaseProvider));
});


final getChatSessionsUseCaseProvider=Provider<GetChatSessionsUseCase>((ref){
  return GetChatSessionsUseCase(ref.watch(repositoryProvider));
});
final chatSessionsViewModelProvider=StateNotifierProvider<ChatSessionsViewModel,AsyncValue<List<ChatSessionEntity>>>((ref){
  return ChatSessionsViewModel(ref.watch(getChatSessionsUseCaseProvider));
});
