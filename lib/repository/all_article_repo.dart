import 'dart:convert';
import 'package:conduit/config/constant.dart';
import 'package:conduit/config/hive_store.dart';
import 'package:conduit/config/shared_preferences_store.dart';
import 'package:conduit/model/all_artist_model.dart';
import 'package:conduit/model/comment_model.dart';
import 'package:conduit/model/new_article_model.dart';
import 'package:conduit/model/user_model.dart';
import 'package:conduit/services/user_client.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;

abstract class AllArticlesRepo {
  Future<List<AllArticlesModel>> getAllArticlesData({int offset, int limit});
  Future<List<AllArticlesModel>> getMyArticles(int offset, int limit);
  Future<List<AllArticlesModel>> getMyFavoriteArticles(int offset, int limit);
  Future<dynamic> addNewArticle(NewArticleModel newArticleModel);
  Future<String> addComment(AddCommentModel addCommentModel, String slug);
  Future<List<CommentModel>> getComment(String slug);
  Future<int> deleteComment(int commentId);
}

class AllArticlesImpl extends AllArticlesRepo {
  @override
  Future<List<AllArticlesModel>> getAllArticlesData(
      {int? offset, int? limit}) async {
    String url = ApiConstant.ALL_Articles + "?offset=$offset&limit=$limit";
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

  Future addNewArticle(NewArticleModel newArticleModel) async {
    String url = ApiConstant.ADD_ARTICLE;
    Map<String, dynamic> body = newArticleModel.toJson();
    http.Response response =
        await UserClient.instance.doPost(ApiConstant.ADD_ARTICLE, body);
    print(body);
    dynamic jsonData = jsonDecode(response.body);
    String message = '';

    if (jsonData['errors'] != null) {
      Map<String, dynamic> errors = jsonData['errors'];
      String fieldName = errors.keys.first;
      String errorValue = errors[fieldName][0];
      message = '$fieldName $errorValue';
    }
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

  Future<int> deleteComment(int commentId) async {
    Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
    String? slug;
    final pref = await sharedPreferencesStore.getSlug();
    slug = await pref['slug'];
    String url = ApiConstant.BASE_COMMENT_URL +
        "/${slug}" +
        ApiConstant.END_COMMENT_URL +
        "/${commentId}";
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
}
