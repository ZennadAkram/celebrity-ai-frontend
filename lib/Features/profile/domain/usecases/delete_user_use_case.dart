import 'package:chat_with_charachter/Features/profile/domain/repositories/profile_repository.dart';

class DeleteUserUseCase{
  final ProfileRepository repository;
  DeleteUserUseCase(this.repository);
  Future<void> call(int id) async{
    repository.deleteUser(id);
  }
}
