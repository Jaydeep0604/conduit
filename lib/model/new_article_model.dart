class NewArticleModel {
  Article? article;

  NewArticleModel({this.article});

  NewArticleModel.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? description;
  String? body;
  String? tagList;

  Article({this.title, this.description, this.body, this.tagList});

  Article.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    body = json['body'];
    tagList = json['tagList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['body'] = this.body;
    data['tagList'] = this.tagList;
    return data;
  }
}
// class NewArticleModel {
//   String? title;
//   String? description;
//   String? body;
//   String? tag;
//   // List<String>? tagList;

//   NewArticleModel({this.title, this.description, this.body, this.tag});

//   NewArticleModel.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     description = json['description'];
//     body = json['body'];
//     tag = json['tagList'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['title'] = this.title;
//     data['description'] = this.description;
//     data['body'] = this.body;
//     data['tagList'] = this.tag;
//     return data;
//   }
// }
