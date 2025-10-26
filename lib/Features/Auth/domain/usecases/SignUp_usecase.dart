import '../../../../Core/Domain/entities/User.dart';
import '../repositories/repository.dart';

class SignUpUseCase{
  final AuthRepository repository;
  SignUpUseCase(this.repository);
  Future<void> call(User user){
    return repository.SignUp(user);
  }
}