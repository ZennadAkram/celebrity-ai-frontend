import 'package:chat_with_charachter/Features/Celebrity/domain/entities/category_entity.dart';

abstract class CategoryRepository{
  Future<List<CategoryEntity>> getCategories();
}