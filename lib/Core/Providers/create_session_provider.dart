
import '../Data/datasources/create_session_data_source.dart';
import '../Data/repositories/create_session_repo_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../Domain/entities/chat_session_entity.dart';
import '../Domain/usecases/create_session_use_case.dart';
import '../Presentation/viewmodels/create_session_viewmodel.dart';

final createSessionRepoProvider=Provider<CreateSessionRepositoryImpl>((ref){
  return CreateSessionRepositoryImpl(ChatSessionsSources());
});
final createSessionUseCaseProvider=Provider<CreateSessionUseCase>((ref){
  return CreateSessionUseCase(ref.watch(createSessionRepoProvider));
});
final createSessionViewModelProvider=StateNotifierProvider<CreateSessionViewModel,AsyncValue<ChatSessionEntity?>>((ref){
  return CreateSessionViewModel(ref.watch(createSessionUseCaseProvider));
});