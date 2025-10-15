import 'package:chat_with_charachter/Features/Celebrity/data/datasources/data_source.dart';
import 'package:chat_with_charachter/Features/Celebrity/domain/entities/celebrity.dart';

import '../../domain/repository/celebrity_repository.dart';

class CelebrityRepositoryImpl implements CelebrityRepository {
  final DataSourceCelebrity _dataSourceCelebrity;
  CelebrityRepositoryImpl(this._dataSourceCelebrity);
  @override
  Future<void> createCelebrity(CelebrityEntity celebrity) {
    // TODO: implement createCelebrity
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCelebrity(int id) {
    // TODO: implement deleteCelebrity
    throw UnimplementedError();
  }

  @override
  Future<List<CelebrityEntity>> getCelebrities(String? category) async{
    final models=await _dataSourceCelebrity.getCelebrities(category);
    return models.map((e) => e.toEntity()).toList();


  }

}