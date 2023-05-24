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

class ProfileModel {
  String? username;
  String? bio;
  String? image;
  bool? following;

  ProfileModel({this.username, this.bio, this.image, this.following});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    username = json.values.last['username'];
    bio = json.values.last['bio'];
    image = json.values.last['image'];
    following = json.values.last['following'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['bio'] = this.bio;
    data['image'] = this.image;
    data['following'] = this.following;
    return data;
  }
}
