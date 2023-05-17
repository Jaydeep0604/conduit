import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserAccessData {
  @HiveField(0)
  String? email;

  @HiveField(1)
  String? userName;

  @HiveField(2)
  String? bio;

  @HiveField(3)
  String? image;

  @HiveField(4)
  String? token;

  UserAccessData({this.email, this.userName, this.bio, this.image, this.token});
}
