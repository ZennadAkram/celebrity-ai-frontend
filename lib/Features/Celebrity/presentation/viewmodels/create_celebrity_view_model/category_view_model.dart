import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../domain/entities/category_entity.dart';
import '../../../domain/usecases/get_categories_use_case.dart';

class CategoryViewModel extends StateNotifier<AsyncValue<List<CategoryEntity>>>{
  final GetCategoriesUseCase _useCase;
  CategoryViewModel(this._useCase):super(const AsyncLoading()){
    getCategories();
  }
  Future<void> getCategories()async{
    state=const AsyncLoading();
    try{
      final categories=await _useCase();
      state=AsyncData(categories);
    }catch(e,st){
      state=AsyncError(e,st);
    }

  }


}