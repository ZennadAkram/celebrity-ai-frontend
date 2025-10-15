import 'package:chat_with_charachter/Features/Celebrity/domain/entities/celebrity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/usecases/get_celebrities_use_case.dart';

class getCelebrityViewModel extends StateNotifier<AsyncValue<List<CelebrityEntity>>>{
  final GetCelebrityUseCase _useCase;
  getCelebrityViewModel(this._useCase):super(const AsyncLoading()){
    getCelebrities("");
  }
  Future<void> getCelebrities(String? category) async{
    state=AsyncLoading();
    try{
      state=AsyncData(await _useCase(category));
    }catch(e,st){
      state=AsyncError(e, st);
    }
}
  void addCelebrity(CelebrityEntity celeb) {
    state = AsyncData([celeb]); // 👈 replaces everything with only this one
  }
}