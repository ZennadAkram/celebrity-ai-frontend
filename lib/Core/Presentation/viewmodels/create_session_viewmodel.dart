import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../Domain/entities/chat_session_entity.dart';
import '../../Domain/usecases/create_session_use_case.dart';

class CreateSessionViewModel extends StateNotifier<AsyncValue<ChatSessionEntity?>>{
  final CreateSessionUseCase _useCase;
  CreateSessionViewModel( this._useCase):super(const AsyncData(null));

  Future<ChatSessionEntity> createSession(int celebrityId) async{
    state = const AsyncLoading();
    final result = await _useCase(celebrityId);
    state = AsyncData(result);
    return result;

  }

}