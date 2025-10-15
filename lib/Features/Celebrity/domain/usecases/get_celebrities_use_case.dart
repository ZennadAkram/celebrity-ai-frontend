import 'package:chat_with_charachter/Features/Celebrity/domain/entities/celebrity.dart';
import 'package:chat_with_charachter/Features/Celebrity/domain/repository/celebrity_repository.dart';

class GetCelebrityUseCase{
  final CelebrityRepository repository;
  GetCelebrityUseCase(this.repository);
  Future<List<CelebrityEntity>> call(String? category){
    return repository.getCelebrities(category);
  }
}