import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserAccessData {
  @HiveField(0)
  String? token;

  @HiveField(1)
  String? userId;

  @HiveField(2)
  String? userName;

  @HiveField(4)
  String? bio;

  @HiveField(3)
  String? image;

  @HiveField(5)
  String? email;

    UserAccessData({
    this.email,
    this.userId,
    this.token,
    this.image,
    this.bio,
    this.userName

  });
}
