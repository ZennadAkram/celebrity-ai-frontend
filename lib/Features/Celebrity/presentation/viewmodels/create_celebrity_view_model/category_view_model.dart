import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../../Core/Services/file_helper.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/usecases/get_categories_use_case.dart';
import '../../providers/create_celebrity_providers/avatar_select_provider.dart';

class CategoryViewModel extends StateNotifier<AsyncValue<List<CategoryEntity>>>{
  final GetCategoriesUseCase _useCase;
  final Ref ref;
  CategoryViewModel(this._useCase, this.ref):super(const AsyncLoading()){
    getCategories();
  }
  Future<void> getCategories()async{
    state=const AsyncLoading();
    try{
      final categories=await _useCase();
      state=AsyncData(categories);
      File file = await FileHelper.assetToFile('images/avatars/3D/boy3D.png');
      ref.read(imageSelectorProvider.notifier).state = file;
    }catch(e,st){
      state=AsyncError(e,st);
    }

  }


}