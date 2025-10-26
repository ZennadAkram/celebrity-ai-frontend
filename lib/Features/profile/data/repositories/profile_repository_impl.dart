import 'package:chat_with_charachter/Core/Domain/entities/User.dart';
import 'package:chat_with_charachter/Features/profile/data/models/Profile_model.dart';
import 'package:chat_with_charachter/Features/profile/domain/repositories/profile_repository.dart';

import '../datasources/profile_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository{
  final ProfileDataSource dataSource;
  ProfileRepositoryImpl({required this.dataSource});
  @override
  Future<void> deleteUser(int id) {
    return dataSource.deleteUser(id);

  }

  @override
  Future<void> editUser(User user) {

    return dataSource.editUser(ProfileModel.fromEntity(user));
  }

  @override
  Future<User> getUser() async{
    final profileModel=await dataSource.getUser();
    return profileModel.toEntity();

  }
  
}