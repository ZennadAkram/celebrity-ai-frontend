import 'package:chat_with_charachter/Core/Domain/entities/User.dart';
import 'package:chat_with_charachter/Features/profile/domain/repositories/profile_repository.dart';

class EditUserUseCase{
  final ProfileRepository repository;
  EditUserUseCase(this.repository);
  Future<void> call(User user) async{
    repository.editUser(user);
  }
}