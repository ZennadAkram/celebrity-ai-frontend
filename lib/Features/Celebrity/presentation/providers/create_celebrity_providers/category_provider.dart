import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/category_data_source.dart';
import '../../../data/repository/category_repository_impl.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/usecases/get_categories_use_case.dart';
import '../../viewmodels/create_celebrity_view_model/category_view_model.dart';
import 'package:flutter_riverpod/legacy.dart';
final categoryRepositoryProvider=Provider<CategoryRepositoryImpl>((ref){
  return CategoryRepositoryImpl(CategoryDataSource());
});

final categoryProvider=Provider<GetCategoriesUseCase>((ref){
  final repository=ref.watch(categoryRepositoryProvider);
  return GetCategoriesUseCase(repository);
});

final categoryViewModelProvider=StateNotifierProvider<CategoryViewModel,AsyncValue<List<CategoryEntity>>>((ref){
  final useCase=ref.watch(categoryProvider);
  return CategoryViewModel(useCase);
});

final categorySelectProvider=StateProvider<int>((ref)=>-1);

