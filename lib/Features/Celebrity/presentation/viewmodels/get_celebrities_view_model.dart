import 'dart:io';

import 'package:chat_with_charachter/Features/Celebrity/domain/entities/celebrity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/usecases/create_celebrity_use_case.dart';
import '../../domain/usecases/get_celebrities_use_case.dart';
import '../providers/celebrity_providers.dart';

class getCelebrityViewModel extends StateNotifier<AsyncValue<List<CelebrityEntity>>>{
  final GetCelebrityUseCase _useCase;
  final CreateCelebrityUseCase _createUseCase;
  getCelebrityViewModel(this._useCase, this._createUseCase):super(const AsyncLoading()){
    getCelebrities("");
  }
  final TextEditingController nameController=TextEditingController();
  final TextEditingController descriptionController=TextEditingController();
  final TextEditingController greetingController=TextEditingController();
  final TextEditingController appearanceController=TextEditingController();

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
  void onCreateCelebrity(WidgetRef ref, File selectedImage) {
    final gender = ref.read(genderProvider);
    final isPrivate = ref.read(isPrivateProvider);
    final category = ref.read(categoryProvider);

    final description = '''
Description: ${descriptionController.text.trim()}
Gender: $gender
Greeting: ${greetingController.text.trim()}
Appearance: ${appearanceController.text.trim()}
''';

    final celebrity = CelebrityEntity(
      name: nameController.text.trim(),
      description: description.trim(),
      isPrivate: isPrivate,
      category: category,
      image: selectedImage,
    );

    createCelebrity(celebrity);
  }

  Future<void> createCelebrity(CelebrityEntity celeb) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _createUseCase(celeb);
      final current = state.value ?? [];
      return [...current, celeb];
    });
  }
  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    greetingController.dispose();
    appearanceController.dispose();
    super.dispose();
  }

}