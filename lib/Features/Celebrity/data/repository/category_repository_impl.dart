import 'package:chat_with_charachter/Features/Celebrity/domain/entities/category_entity.dart';

import '../../domain/repository/category_repository.dart';
import '../datasources/category_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource dataSource;

  CategoryRepositoryImpl(this.dataSource);

  @override
  Future<List<CategoryEntity>> getCategories() async{
    final model=await dataSource.getCategories();
    return model.map((e) => e.toEntity()).toList();
  
  }
  // Implementation details would go here
}