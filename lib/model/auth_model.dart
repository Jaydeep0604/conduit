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

