// class AllArticlesModel {
//   List<Articles>? articles;
//   int? articlesCount;

//   AllArticlesModel({this.articles, this.articlesCount});

//   AllArticlesModel.fromJson(Map<String, dynamic> json) {
//     if (json['articles'] != null) {
//       articles = <Articles>[];
//       json['articles'].forEach((v) {
//         articles!.add(new Articles.fromJson(v));
//       });
//     }
//     articlesCount = json['articlesCount'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.articles != null) {
//       data['articles'] = this.articles!.map((v) => v.toJson()).toList();
//     }
//     data['articlesCount'] = this.articlesCount;
//     return data;
//   }
// }

// class Articles {
//   String? slug;
//   String? title;
//   String? description;
//   String? body;
//   List<String>? tagList;
//   String? createdAt;
//   String? updatedAt;
//   bool? favorited;
//   int? favoritesCount;
//   Author? author;

//   Articles(
//       {this.slug,
//       this.title,
//       this.description,
//       this.body,
//       this.tagList,
//       this.createdAt,
//       this.updatedAt,
//       this.favorited,
//       this.favoritesCount,
//       this.author});

//   Articles.fromJson(Map<String, dynamic> json) {
//     slug = json['slug'];
//     title = json['title'];
//     description = json['description'];
//     body = json['body'];
//     tagList = json['tagList'].cast<String>();
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     favorited = json['favorited'];
//     favoritesCount = json['favoritesCount'];
//     author =
//         json['author'] != null ? new Author.fromJson(json['author']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['slug'] = this.slug;
//     data['title'] = this.title;
//     data['description'] = this.description;
//     data['body'] = this.body;
//     data['tagList'] = this.tagList;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['favorited'] = this.favorited;
//     data['favoritesCount'] = this.favoritesCount;
//     if (this.author != null) {
//       data['author'] = this.author!.toJson();
//     }
//     return data;
//   }
// }

// class Author {
//   String? username;
//   String? bio;
//   String? image;
//   bool? following;

//   Author({this.username, this.bio, this.image, this.following});

//   Author.fromJson(Map<String, dynamic> json) {
//     username = json['username'];
//     bio = json['bio'];
//     image = json['image'];
//     following = json['following'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['username'] = this.username;
//     data['bio'] = this.bio;
//     data['image'] = this.image;
//     data['following'] = this.following;
//     return data;
//   }
// }
class AllArticlesModel {
  String? slug;
  String? title;
  String? description;
  String? body;
  List<String>? tagList;
  String? createdAt;
  String? updatedAt;
  late bool favorited;
  int? favoritesCount;
  Author? author;
  bool liked = false;

  AllArticlesModel(
      {this.slug,
      this.title,
      this.description,
      this.body,
      this.tagList,
      this.createdAt,
      this.updatedAt,
      required this.favorited,
      this.favoritesCount,
      this.author,
      required this.liked});

  AllArticlesModel.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    title = json['title'];
    description = json['description'];
    body = json['body'];
    tagList = json['tagList'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    favorited = json['favorited'];
    favoritesCount = json['favoritesCount'];
    author =
        json['author'] != null ? new Author.fromJson(json['author']) : null;
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slug'] = this.slug;
    data['title'] = this.title;
    data['description'] = this.description;
    data['body'] = this.body;
    data['tagList'] = this.tagList;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['favorited'] = this.favorited;
    data['favoritesCount'] = this.favoritesCount;
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    return data;
  }
}

class Author {
  String? username;
  String? bio;
  String? image;
  late bool following;

  Author({this.username, this.bio, this.image, required this.following});

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
