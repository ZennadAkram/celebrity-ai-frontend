import 'package:chat_with_charachter/Features/Chats/domain/usecases/delete_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Core/Domain/entities/chat_session_entity.dart';
import '../../domain/usecases/get_chat_session_use_case.dart';
import 'package:flutter_riverpod/legacy.dart';
class ChatSessionsViewModel extends StateNotifier<AsyncValue<List<ChatSessionEntity>>> {
  final GetChatSessionsUseCase _useCase;
  final DeleteSessionUseCase _deleteUseCase;

  ChatSessionsViewModel(this._useCase, this._deleteUseCase) : super(const AsyncLoading()) {
    getChatSessions(1);
  }

  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool hasMore = true;
  bool isInitialLoad = true;
  List<ChatSessionEntity> _allSessions = [];

  /// Initial load
  Future<void> getChatSessions(int page) async {
    try {
      final sessions = await _useCase(page);
      _allSessions = sessions;
      hasMore = sessions.isNotEmpty && sessions.length == 15;
      state = AsyncData(_allSessions);
      isInitialLoad = false;
      _currentPage = 2;
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  Future<void> deleteSession(int index,int id) async {
    try{
      await _deleteUseCase(id);
      state=AsyncData(List.from(state.value?? [])..removeAt(index));

    }catch(e,st){
      state = AsyncError(e, st);
    }

  }

void addSession(ChatSessionEntity session){
    _allSessions.add(session);
  state = AsyncData(List.from(_allSessions)); // update state immutably
}
  /// Called when user scrolls to the bottom
  Future<void> loadMore() async {
    if (state.isLoading || _isLoadingMore || !hasMore) return;


    _isLoadingMore = true;

    try {
      final nextSessions = await _useCase(_currentPage);

      if (nextSessions.length < 15) {
        if(nextSessions.isNotEmpty){
          _allSessions.addAll(nextSessions);
          state = AsyncData(List.from(_allSessions)); // update state immutably
        }
        hasMore = false;
      } else {
        _allSessions.addAll(nextSessions);
        state = AsyncData(List.from(_allSessions)); // update state immutably
        _currentPage++;
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }
}
