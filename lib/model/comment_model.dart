class CommentModel {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? body;
  Author? author;

  CommentModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.body,
    this.author,
  });

  factory CommentModel.fromJson(Map<String, dynamic>? json) {
    return CommentModel(
      id: json?['id'] as int?,
      createdAt: json?['createdAt'] as String?,
      updatedAt: json?['updatedAt'] as String?,
      body: json?['body'] as String?,
      author: json?['author'] != null
          ? Author.fromJson(json?['author'] as Map<String, dynamic>?)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['body'] = body;
    if (author != null) {
      data['author'] = author!.toJson();
    }
    return data;
  }
}

class Author {
  String? username;
  String? bio;
  String? image;
  bool? following;

  Author({
    this.username,
    this.bio,
    this.image,
    this.following,
  });

  factory Author.fromJson(Map<String, dynamic>? json) {
    return Author(
      username: json?['username'] as String?,
      bio: json?['bio'] as String?,
      image: json?['image'] as String?,
      following: json?['following'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['bio'] = bio;
    data['image'] = image;
    data['following'] = following;
    return data;
  }
}

class AddCommentModel {
  Comment? comment;

  AddCommentModel({this.comment});

  factory AddCommentModel.fromJson(Map<String, dynamic> json) {
    return AddCommentModel(
      comment: json['comment'] != null
          ? Comment.fromJson(json['comment'] as Map<String, dynamic>?)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (comment != null) {
      data['comment'] = comment!.toJson();
    }
    return data;
  }
}

class Comment {
  String? body;

  Comment({this.body});

  factory Comment.fromJson(Map<String, dynamic>? json) {
    return Comment(
      body: json?['body'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['body'] = body;
    return data;
  }
}
