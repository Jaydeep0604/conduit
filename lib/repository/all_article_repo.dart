import 'dart:convert';
import 'package:conduit/config/constant.dart';
import 'package:conduit/config/hive_store.dart';
import 'package:conduit/model/all_artist_model.dart';
import 'package:conduit/model/comment_model.dart';
import 'package:conduit/model/new_article_model.dart';
import 'package:conduit/model/profile_model.dart';
import 'package:conduit/model/user_model.dart';
import 'package:conduit/services/user_client.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;

abstract class AllArticlesRepo {
  Future<List<AllArticlesModel>> getAllArticlesData({int offset, int limit});
  Future<List<AllArticlesModel>> getMyArticles(int offset, int limit);
  Future<List<CommentModel>> deleteArticle(String slug);
  Future<List<AllArticlesModel>> getMyFavoriteArticles(int offset, int limit);
  Future<dynamic> addNewArticle(ArticleModel newArticleModel);
  Future<dynamic> updateArticle(ArticleModel newArticleModel, String slug);
  Future<String> addComment(AddCommentModel addCommentModel, String slug);
  Future<List<ArticleModel>> getArticle(String slug);
  Future<List<CommentModel>> getComment(String slug);
  Future<int> deleteComment(int commentId, String slug);
  Future<List<ProfileModel>> getProfileData();
  Future<dynamic> updateProfile(ProfileModel profileModel);
  Future<bool> logOut();
}

class AllArticlesImpl extends AllArticlesRepo {
  @override
  Future<List<AllArticlesModel>> getAllArticlesData(
      {int? offset, int? limit}) async {
    String url = ApiConstant.ALL_Articles + "?offset=$offset&limit=$limit";
    Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
    // final pref = await sharedStore.getAllData();
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        // "Authorization": "Bearer ${pref["token"]}"
        "Authorization": "Bearer ${detailModel!.values.first.token}"
      },
    );
    Map<String, dynamic> jsonData = json.decode(response.body);
    // dynamic jsonData =jsonDecode(response.body);
    if (response.statusCode == 200) {
      // dynamic data = jsonDecode(jsonData);
      List<dynamic> data = jsonData["articles"];
      List<AllArticlesModel> s =
          List.from((data).map((e) => AllArticlesModel.fromJson(e)));
      return s;
    } else {
      throw Exception();
    }
  }

  Future<List<AllArticlesModel>> getMyArticles(int offset, int limit) async {
    Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
    String url = ApiConstant.MY_ARTICLES +
        "${detailModel?.values.first.userName}" +
        "&offset=$offset&limit=$limit";
    // String url = ApiConstant.ALL_Articles + "?offset=$offset&limit=$limit";
    http.Response response = await http.get(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": "Bearer ${detailModel?.values.first.token}"
    });
    Map<String, dynamic> jsonData = json.decode(response.body);
    int totalCount = jsonData['articlesCount'];
    print(totalCount);
    // Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonData["articles"];
      List<AllArticlesModel> s =
          List.from((data).map((e) => AllArticlesModel.fromJson(e)));
      return s;
    } else {
      throw Exception();
    }
  }

  Future<List<AllArticlesModel>> getMyFavoriteArticles(
      int offset, int limit) async {
    Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
    String url = ApiConstant.MY_FAVORITE_ARTICLES +
        "${detailModel?.values.first.userName}" +
        "&offset=$offset&limit=$limit";
    // String url = ApiConstant.ALL_Articles + "?offset=$offset&limit=$limit";
    http.Response response = await http.get(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": "Bearer ${detailModel?.values.first.token}"
    });
    Map<String, dynamic> jsonData = json.decode(response.body);
    int totalCount = jsonData['articlesCount'];
    print(totalCount);
    // Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonData["articles"];
      List<AllArticlesModel> s =
          List.from((data).map((e) => AllArticlesModel.fromJson(e)));
      return s;
    } else {
      throw Exception();
    }
  }

  Future addNewArticle(ArticleModel newArticleModel) async {
    String url = ApiConstant.ADD_ARTICLE;
    Map<String, dynamic> body = newArticleModel.toJson();
    http.Response response = await UserClient.instance.doPostArticle(url, body);
    print(body);
    dynamic jsonData = jsonDecode(response.body);
    String message = '';

    if (jsonData['errors'] != null) {
      Map<String, dynamic> errors = jsonData['errors'];
      String fieldName = errors.keys.first;
      String errorValue = errors[fieldName][0];
      message = '$fieldName $errorValue';
    }
    // for error text shoe only
    // if (jsonData['errors'] != null) {
    //   Map<String, dynamic> errors = jsonData['errors'];
    //   String fieldName = errors.keys.first;
    //   errorMessage = errors[fieldName][0];
    //   // Remove unnecessary parts
    //   errorMessage = errorMessage
    //       .replaceAll('{"$fieldName":', '')
    //       .replaceAll('[', '')
    //       .replaceAll(']', '')
    //       .replaceAll('"', '');
    // }
    if (response.statusCode == 200) {
      // dynamic jsonData = jsonDecode(response.body);
      return message;
    } else if (response.statusCode == 403) {
      throw message;
    } else {
      throw message;
    }
  }

  Future<List<ArticleModel>> getArticle(String slug) async {
    String url = ApiConstant.GET_ARTICLE + "/${slug}";
    print(url);
    Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer ${detailModel!.values.first.token}"
      },
    );
    Map<String, dynamic> jsonData = json.decode(response.body);
    // dynamic jsonData =jsonDecode(response.body);
    if (response.statusCode == 200) {
      ArticleModel articleModel = ArticleModel.fromJson(jsonData);
      return [articleModel];  

      // dynamic data = jsonDecode(jsonData);
      // List<dynamic> data = jsonData["articles"];
      // List<ArticleModel> s =
      //     List.from((data).map((e) => ArticleModel.fromJson(e)));
      // return s;
    } else {
      throw Exception();
    }
  }

  //   Map<String, dynamic> jsonData = json.decode(response.body);
  //   if (response.statusCode == 200) {
  //     List<dynamic> data = jsonData['article'];
  //     print(data);
  //     List<Article> s = List<Article>.from(
  //         data.map((e) => Article.fromJson(e as Map<String, dynamic>)));
  //     return s;
  //   } else {
  //     throw Exception();
  //   }
  // }

  Future updateArticle(ArticleModel newArticleModel, String slug) async {
    String url = ApiConstant.UPDATE_ARTICLE + "/${slug}";

    Map<String, dynamic> body = newArticleModel.toJson();

    http.Response response =
        await UserClient.instance.doUpdateArticle(url, body);
    print(body);
    dynamic jsonData = jsonDecode(response.body);
    String message = '';

    if (jsonData['errors'] != null) {
      Map<String, dynamic> errors = jsonData['errors'];
      String fieldName = errors.keys.first;
      String errorValue = errors[fieldName][0];
      message = '$fieldName $errorValue';
    }
    if (response.statusCode == 200) {
      return message;
    } else if (response.statusCode == 403) {
      throw message;
    } else {
      throw message;
    }
  }

  Future<String> addComment(
      AddCommentModel addCommentModel, String slug) async {
    //another way to store slug
    // String? slug;
    // final pref = await sharedPreferencesStore.getSlug();
    // slug = await pref['slug'];
    // String url =
    // "https://api.realworld.io/api/articles/Creativity_Is_a_Process_Not_an_Event-179946/comments";,
    String url =
        ApiConstant.BASE_COMMENT_URL + "/${slug}" + ApiConstant.END_COMMENT_URL;
    print(url);
    Map<String, dynamic> body = addCommentModel.toJson();
    http.Response response = await UserClient.instance.doPostComment(url, body);
    print(body);
    dynamic jsonData = jsonDecode(response.body);
    String message = '';
    if (jsonData['errors'] != null) {
      Map<String, dynamic> errors = jsonData['errors'];
      String fieldName = errors.keys.first;
      String errorValue = errors[fieldName][0];
      message = '$fieldName $errorValue';
    }
    if (response.statusCode == 200) {
      // dynamic jsonData = jsonDecode(response.body);
      return message;
    } else if (response.statusCode == 403) {
      throw message;
    } else {
      throw message;
    }
  }

  Future<List<CommentModel>> getComment(String slug) async {
    String url =
        ApiConstant.BASE_COMMENT_URL + "/${slug}" + ApiConstant.END_COMMENT_URL;
    print(url);
    Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer ${detailModel!.values.first.token}"
      },
    );
    Map<String, dynamic> jsonData = json.decode(response.body);
    // dynamic jsonData =jsonDecode(response.body);
    if (response.statusCode == 200) {
      // dynamic data = jsonDecode(jsonData);
      List<dynamic> data = jsonData["comments"];
      print(data);
      List<CommentModel> s = List<CommentModel>.from(
          data.map((e) => CommentModel.fromJson(e as Map<String, dynamic>)));
      return s;
    } else {
      throw Exception();
    }
  }

  Future<List<CommentModel>> deleteArticle(String slug) async {
    String url = ApiConstant.BASE_COMMENT_URL + "/${slug}";
    print(url);
    Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
    http.Response response = await http.delete(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer ${detailModel!.values.first.token}"
      },
    );
    Map<String, dynamic> jsonData = json.decode(response.body);
    // dynamic jsonData =jsonDecode(response.body);
    if (response.statusCode == 200) {
      // dynamic data = jsonDecode(jsonData);
      List<dynamic> data = jsonData["comments"];
      print(data);
      List<CommentModel> s = List<CommentModel>.from(
          data.map((e) => CommentModel.fromJson(e as Map<String, dynamic>)));
      return s;
    } else {
      throw Exception();
    }
  }

  Future<int> deleteComment(int commentId, String slug) async {
    Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
    // final pref = await sharedPreferencesStore.getSlug();
    // slug = await pref['slug'];
    String url = ApiConstant.BASE_COMMENT_URL +
        "/${slug}" +
        ApiConstant.END_COMMENT_URL +
        "/${commentId}";
    print("created url is :: $url");
    http.Response response = await http.delete(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer ${detailModel!.values.first.token}"
      },
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw Exception('Failed to delete comment');
    }
  }

  @override
  Future<List<ProfileModel>> getProfileData() async {
    Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
    String url = ApiConstant.USER_PROFILE;
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer ${detailModel!.values.first.token}"
      },
    );
    Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      // sharedStore.logOut();
      // await sharedStore.openSession(jsonData["token"]);
      ProfileModel profile = ProfileModel.fromJson(jsonData);
      return [profile]; // Wrap the profile in a list and return
    } else {
      throw Exception();
    }
  }

  Future updateProfile(ProfileModel profileModel) async {
    String url = ApiConstant.UPDATE_USER;
    Map<String, dynamic> body = profileModel.toJson();
    http.Response response =
        await UserClient.instance.doUpdateProfile(url, body);
    // print(body);
    dynamic jsonData = jsonDecode(response.body);
    String message = '';
    await hiveStore.logOut();
    if (jsonData['errors'] != null) {
      Map<String, dynamic> errors = jsonData['errors'];
      String fieldName = errors.keys.first;
      String errorValue = errors[fieldName][0];
      message = '$fieldName $errorValue';
    }
    if (response.statusCode == 200) {
      bool isSessionOpen = await hiveStore.openSession(
        UserAccessData(
          email: jsonData["email"],
          userName: jsonData["username"],
          bio: jsonData["bio"],
          image: jsonData["image"],
          token: jsonData["token"],
        ),
      );
      return jsonData;
    } else if (response.statusCode == 403) {
      throw message;
    } else {
      throw message;
    }
  }

  @override
  Future<bool> logOut() async {
    await hiveStore.logOut();
    if (hiveStore.logOut() == true) {
      return true;
    } else {
      throw Exception("Something went wrong try again later");
    }
  }
}
