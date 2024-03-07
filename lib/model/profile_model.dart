class ProfileModel {
  User? user;

  ProfileModel({this.user});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? email;
  String? username;
  String? bio;
  String? image;
  String? password;

  User({
    this.email,
    this.username,
    this.bio,
    this.image,
    this.password,
  });

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    username = json['username'];
    bio = json['bio'];
    image = json['image'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['username'] = this.username;
    data['bio'] = this.bio;
    data['image'] = this.image;
    data['password'] = this.password;
    return data;
  }
}
