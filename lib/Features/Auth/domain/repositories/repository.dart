import '../entities/User.dart';

abstract class AuthRepository{
  Future<void> SignUp(User user);
  Future<void> SignIn(String username,String password);
  Future<User> getUser();


}