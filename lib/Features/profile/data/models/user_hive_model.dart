import 'package:hive/hive.dart';
import 'package:chat_with_charachter/Core/Domain/entities/User.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 1)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? avatarUrl;

  UserHiveModel({
    required this.id,
    required this.userName,
    this.email,
    this.avatarUrl,
  });

  // Convert Hive model back to entity
  User toEntity() => User(
    id: id,
    userName: userName,
    email: email,
    avatarUrl: avatarUrl,
  );

  // Create Hive model from entity
  factory UserHiveModel.fromEntity(User user) => UserHiveModel(
    id: user.id,
    userName: user.userName,
    email: user.email,
    avatarUrl: user.avatarUrl,
  );
}
