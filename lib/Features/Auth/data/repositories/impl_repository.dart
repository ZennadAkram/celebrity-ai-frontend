import 'package:chat_with_charachter/Core/Domain/entities/User.dart';
import 'package:chat_with_charachter/Features/Auth/domain/repositories/repository.dart';

import '../datasources/data_source.dart';
import '../models/UserModel.dart';

class ImplRepository implements AuthRepository{
final DataSource dataSource;
ImplRepository(this.dataSource);

  @override
  Future<void> SignIn(String username, String password) async{
await dataSource.SignIn(username, password);


  }

  @override
  Future<void> SignUp(User user) {
    final model=UserModel.fromEntity(user);
    model.setPassword(user.getPassword()??"");
    return dataSource.signUp(model);
  }



}