import 'package:chat_with_charachter/Core/Domain/entities/User.dart';

abstract class ProfileRepository{
  Future<User> getUser();
  Future<void> editUser(User user);
  Future<void> deleteUser(int id);
}