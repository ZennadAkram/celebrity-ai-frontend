import 'package:chat_with_charachter/Core/Domain/entities/User.dart';
import 'package:chat_with_charachter/Features/profile/data/models/Profile_model.dart';
import 'package:chat_with_charachter/Features/profile/domain/repositories/profile_repository.dart';

import '../../../../Core/Services/user_local_data_source.dart';
import '../datasources/profile_data_source.dart';
import '../models/user_hive_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource dataSource;
  ProfileRepositoryImpl({required this.dataSource});

  @override
  Future<User> getUser() async {
    try {
      // First try local storage
      final localUser = await UserLocalStorage.getUser();
      if (localUser != null) return localUser.toEntity();

      // Otherwise fetch from API
      final profileModel = await dataSource.getUser();
      // Save locally
      await UserLocalStorage.saveUser(UserHiveModel.fromEntity(profileModel.toEntity()));
      return profileModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editUser(User user) async {
   final avatarUrl = await dataSource.editUser(ProfileModel.fromEntity(user));
   
    await UserLocalStorage.saveUser(UserHiveModel.fromEntity(User(userName: user.userName, email: user.email, avatarUrl: avatarUrl,id:user.id )));
  }

  @override
  Future<void> deleteUser(int id) async {
    await dataSource.deleteUser(id);
    await UserLocalStorage.deleteUser();
  }
}
