// part 'auth_model.g.dart';
// class AuthModel {
//   User? user;
//   AuthModel({this.user});
//   AuthModel.fromJson(Map<String, dynamic> json) {
//     user = json['user'] != null ? new User.fromJson(json['user']) : null;
//   }
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.user != null) {
//       data['user'] = this.user!.toJson();
//     }
//     return data;
//   }
// }
// class User {
//   String? email;
//   String? username;
//   String? password;
//   String? bio;
//   String? image;
//   String? token;
//   User({this.email, this.username,this.password, this.bio, this.image, this.token});
//   User.fromJson(Map<String, dynamic> json) {
//     email = json['email'];
//     username = json['username'];
//     password = json['password'];
//     bio = json['bio'];
//     image = json['image'];
//     token = json['token'];
//   }
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['email'] = this.email;
//     data['username'] = this.username;
//     data['password'] = this.password;
//     data['bio'] = this.bio;
//     data['image'] = this.image;
//     data['token'] = this.token;
//     return data;
//   }
// }


class AuthModel {
  String? email;
  String? username;
  String? password;
  String? bio;
  String? image;
  String? token;

  AuthModel({this.email, this.username,this.password, this.bio, this.image, this.token});

  AuthModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    username = json['username'];
    password=json['password'];
    bio = json['bio'];
    image = json['image'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['username'] = this.username;
    data['password']=this.password;
    data['bio'] = this.bio;
    data['image'] = this.image;
    data['token'] = this.token;
    return data;
  }
}

