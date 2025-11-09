import '../../../../Core/Domain/entities/User.dart';

abstract class AuthRepository{
  Future<String> SignUp(User user);
  Future<String> SignIn(String username,String password);



}