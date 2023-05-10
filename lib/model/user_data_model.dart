import 'package:hive/hive.dart';
part 'user_data_model.g.dart';

@HiveType(typeId: 2)
class UserData {
  @HiveField(0)
  String? token;

  @HiveField(1)
  String userName;

  @HiveField(2)
  String bio;

  @HiveField(3)
  String image;

  @HiveField(4)
  String email;




  UserData({
    required this.email,
    this.token,
    required this.image,
    required this.bio,
    required this.userName

  });
}