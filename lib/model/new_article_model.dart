class ArticleModel {
  Article? article;

  ArticleModel({this.article});

  ArticleModel.fromJson(Map<String, dynamic> json) {
    article =
        json['article'] != null ? new Article.fromJson(json['article']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.article != null) {
      data['article'] = this.article!.toJson();
    }
    return data;
  }
}

class Article {
  String? slug;
  String? title;
  String? description;
  String? body;
  List<String>? tagList;
  // String? tagList;
  String? createdAt;
  String? updatedAt;
  bool? favorited;
  int? favoritesCount;
  Author? author;

  Article(
      {this.slug,
      this.title,
      this.description,
      this.body,
      this.tagList,
      this.createdAt,
      this.updatedAt,
      this.favorited,
      this.favoritesCount,
      this.author});

  Article.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    title = json['title'];
    description = json['description'];
    body = json['body'];
    // if (json['tagList'] != null) {
    //   tagList = <String>[];
    //   json['tagList'];
    // }
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
    // if (this.tagList != null) {
    //   data['tagList'];
    // }
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
