import 'package:chat_with_charachter/Features/Celebrity/domain/repository/category_repository.dart';

import '../entities/category_entity.dart';

class GetCategoriesUseCase{
  final CategoryRepository repository;
  GetCategoriesUseCase(this.repository);
  Future<List<CategoryEntity>> call(){
    return repository.getCategories();
  }



}