import 'package:chat_with_charachter/Core/Domain/entities/User.dart';
import 'package:chat_with_charachter/Features/profile/domain/repositories/profile_repository.dart';

class GetUserUseCase{
  final ProfileRepository repository;
  GetUserUseCase(this.repository);
  Future<User> call(){
    return repository.getUser();
  }
}