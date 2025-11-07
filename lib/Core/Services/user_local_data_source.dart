import 'package:hive/hive.dart';
import '../../Features/profile/data/models/user_hive_model.dart';


class UserLocalStorage {
  static const String boxName = "userBox";

  static Future<void> saveUser(UserHiveModel user) async {
    final box = await Hive.openBox<UserHiveModel>(boxName);
    await box.put('currentUser', user); // store with a fixed key
    await box.close();
  }

  static Future<UserHiveModel?> getUser() async {
    final box = await Hive.openBox<UserHiveModel>(boxName);
    final user = box.get('currentUser');
    await box.close();
    return user;
  }

  static Future<void> deleteUser() async {
    final box = await Hive.openBox<UserHiveModel>(boxName);
    await box.delete('currentUser');
    await box.close();
  }
}
