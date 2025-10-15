import '../repositories/repository.dart';

class SignInUseCase{
  final AuthRepository repository;
  SignInUseCase(this.repository);
  Future<void> call(String username,String password){
    return repository.SignIn(username, password);
  }

}