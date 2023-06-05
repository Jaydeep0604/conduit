// class ProfileModel {
//   Profile? profile;

//   ProfileModel({this.profile});

//   ProfileModel.fromJson(Map<String, dynamic> json) {
//     profile =
//         json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.profile != null) {
//       data['profile'] = this.profile!.toJson();
//     }
//     return data;
//   }
// }

// class ProfileModel {
//   String? email;
//   String? username;
//   String? bio;
//   String? image;
//   bool? following;

//   ProfileModel({this.username, this.bio, this.image, this.following,this.email});

//   ProfileModel.fromJson(Map<String, dynamic> json) {
//     email = json['email'];
//     username = json['username'];
//     bio = json['bio'];
//     image = json['image'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['email'] = this.email;
//     data['username'] = this.username;
//     data['bio'] = this.bio;
//     data['image'] = this.image;
//     return data;
//   }
// }
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
  // String? token;

  User({this.email, this.username, this.bio, this.image});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    username = json['username'];
    bio = json['bio'];
    image = json['image'];
    // token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['username'] = this.username;
    data['bio'] = this.bio;
    data['image'] = this.image;
    // data['token'] = this.token;
    return data;
  }
}
