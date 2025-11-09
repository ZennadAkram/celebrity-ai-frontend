import 'package:chat_with_charachter/Core/Domain/entities/User.dart';
import 'package:chat_with_charachter/Features/Auth/domain/repositories/repository.dart';

import '../datasources/data_source.dart';
import '../models/UserModel.dart';

class ImplRepository implements AuthRepository{
final DataSource dataSource;
ImplRepository(this.dataSource);

  @override
  Future<String> SignIn(String username, String password) async{
final resp= await dataSource.SignIn(username, password);
return resp;


  }

  @override
  Future<String> SignUp(User user) async{
    final model=UserModel.fromEntity(user);
    model.setPassword(user.getPassword()??"");
    return await dataSource.signUp(model);
  }



}