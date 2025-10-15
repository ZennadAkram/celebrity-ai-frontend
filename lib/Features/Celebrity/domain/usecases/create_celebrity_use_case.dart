import 'package:chat_with_charachter/Features/Celebrity/domain/entities/celebrity.dart';
import 'package:chat_with_charachter/Features/Celebrity/domain/repository/celebrity_repository.dart';

class CreateCelebrityUseCase{
  final CelebrityRepository repository;
  CreateCelebrityUseCase(this.repository);
  Future<void> call(CelebrityEntity celebrity){
    return repository.createCelebrity(celebrity);
  }
}