import 'package:chat_with_charachter/Features/Celebrity/data/datasources/data_source.dart';
import 'package:chat_with_charachter/Features/Celebrity/data/models/celebrity_model.dart';
import 'package:chat_with_charachter/Features/Celebrity/domain/entities/celebrity.dart';

import '../../domain/repository/celebrity_repository.dart';

class CelebrityRepositoryImpl implements CelebrityRepository {
  final DataSourceCelebrity _dataSourceCelebrity;
  CelebrityRepositoryImpl(this._dataSourceCelebrity);
  @override
  Future<void> createCelebrity(CelebrityEntity celebrity) async {
    final  model=CelebrityModel.fromEntity(celebrity);
    await _dataSourceCelebrity.createCelebrity(model);
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