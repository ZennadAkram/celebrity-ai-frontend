import 'package:chat_with_charachter/Features/Auth/domain/entities/User.dart';

import '../repositories/repository.dart';

class GetUseUseCase{
  AuthRepository repository;
  GetUseUseCase(this.repository);
  Future<User> call(){
    return repository.getUser();
  }
}