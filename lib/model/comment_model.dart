// class CommentModel {
//   List<Comments>? comments;

//   CommentModel({this.comments});

//   CommentModel.fromJson(Map<String, dynamic> json) {
//     if (json['comments'] != null) {
//       comments = <Comments>[];
//       json['comments'].forEach((v) {
//         comments!.add(new Comments.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.comments != null) {
//       data['comments'] = this.comments!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class CommentModel {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? body;
  Author? author;

  CommentModel({this.id, this.createdAt, this.updatedAt, this.body, this.author});

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    body = json['body'];
    author =
        json['author'] != null ? new Author.fromJson(json['author']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['body'] = this.body;
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    return data;
  }
}

class Author {
  String? username;
  Null? bio;
  String? image;
  bool? following;

  Author({this.username, this.bio, this.image, this.following});

  Author.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    bio = json['bio'];
    image = json['image'];
    following = json['following'];
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

