import 'dart:convert';
import 'package:conduit/config/constant.dart';
import 'package:conduit/config/hive_store.dart';
import 'package:conduit/model/all_article_model.dart';
import 'package:conduit/model/comment_model.dart';
import 'package:conduit/model/new_article_model.dart';
import 'package:conduit/model/profile_model.dart';
import 'package:conduit/model/user_model.dart';
import 'package:conduit/services/user_client.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;

abstract class AllArticlesRepo {
  Future<List<AllArticlesModel>> getAllArticlesData({int offset, int limit});
  Future<List<AllArticlesModel>> getYourFeedData({int offset, int limit});
  Future<List<AllArticlesModel>> getMyArticles(int offset, int limit);
  Future<bool> deleteArticle(String slug);
  Future<List<AllArticlesModel>> getMyFavoriteArticles(int offset, int limit);
  Future<dynamic> addNewArticle(ArticleModel newArticleModel);
  Future<dynamic> updateArticle(ArticleModel newArticleModel, String slug);
  Future<String> addComment(AddCommentModel addCommentModel, String slug);
  Future<List<ArticleModel>> getArticle(String slug);
  Future<List<CommentModel>> getComment(String slug);
  Future<int> deleteComment(int commentId, String slug);
  Future<List<ProfileModel>> getProfileData();
  Future<dynamic> updateProfile(ProfileModel profileModel);
  Future<dynamic> changePassword(ProfileModel profileModel);
  Future<dynamic> fetchAllTags();
  Future<dynamic> fetchSearchTags(String title);
  Future<dynamic> likeArticle(String slug);
  Future<dynamic> removeLikeArticle(String slug);
  Future<dynamic> followUser(String username);
  Future<dynamic> unFollowUser(String username);
}

class AllArticlesImpl extends AllArticlesRepo {
  @override
  Future<List<AllArticlesModel>> getAllArticlesData(
      {int? offset, int? limit}) async {
    String url = ApiConstant.ALL_ARTICLES + "?offset=$offset&limit=$limit";
    http.Response response = await UserClient.instance.doGet(url);
    Map<String, dynamic> jsonData = json.decode(response.body);
    // dynamic jsonData =jsonDecode(response.body);
    if (response.statusCode == 401) {
      dynamic data = response.body;
      return data;
    }
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

  @override
  Future<List<AllArticlesModel>> getYourFeedData(
      {int? offset, int? limit}) async {
    String url = ApiConstant.YOUR_FEED + "?offset=$offset&limit=$limit";
    http.Response response = await UserClient.instance.doGet(url);
    Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 401) {
      dynamic data = response.body;
      return data;
    }
    if (response.statusCode == 200) {
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
    // print(url);
    http.Response response = await UserClient.instance.doGet(url);
    Map<String, dynamic> jsonData = json.decode(response.body);
    // int totalCount = jsonData['articlesCount'];
    // print(totalCount);
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
    http.Response response = await UserClient.instance.doGet(url);
    Map<String, dynamic> jsonData = json.decode(response.body);
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
    // print(body);
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
    if (response.statusCode == 201) {
      // dynamic jsonData = jsonDecode(response.body);
      return response.reasonPhrase.toString();
    } else if (response.statusCode == 403) {
      throw message;
    } else {
      throw message;
    }
  }

  Future<List<ArticleModel>> getArticle(String slug) async {
    String url = ApiConstant.GET_ARTICLE + "/${slug}";
    // print(url);
    http.Response response = await UserClient.instance.doGet(url);
    Map<String, dynamic> jsonData = json.decode(response.body);
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

  Future updateArticle(ArticleModel newArticleModel, String slug) async {
    String url = ApiConstant.UPDATE_ARTICLE + "/${slug}";
    Map<String, dynamic> body = newArticleModel.toJson();
    http.Response response =
        await UserClient.instance.doUpdateArticle(url, body);
    // print(body);
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
    String url =
        ApiConstant.BASE_COMMENT_URL + "/${slug}" + ApiConstant.END_COMMENT_URL;
    print(url);
    Map<String, dynamic> body = addCommentModel.toJson();
    http.Response response = await UserClient.instance.doPostComment(url, body);
    // print(body);
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
      return response.reasonPhrase.toString();
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

    http.Response response = await UserClient.instance.doGet(url);
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

  Future<bool> deleteArticle(String slug) async {
    String url = ApiConstant.BASE_COMMENT_URL + "/${slug}";
    http.Response response = await UserClient.instance.doDelete(url);
    // Map<String, dynamic> jsonData = json.decode(response.body);
    // dynamic jsonData =jsonDecode(response.body);
    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 200 || response.statusCode == 202) {
      return true;
    } else {
      throw Exception();
    }
  }

  Future<int> deleteComment(int commentId, String slug) async {
    String url = ApiConstant.BASE_COMMENT_URL +
        "/${slug}" +
        ApiConstant.END_COMMENT_URL +
        "/${commentId}";
    print("created url is :: $url");
    http.Response response = await UserClient.instance.doDelete(url);
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw Exception('Failed to delete comment');
    }
  }

  @override
  Future<List<ProfileModel>> getProfileData() async {
    String url = ApiConstant.USER_PROFILE;
    http.Response response = await UserClient.instance.doGet(url);
    Map<String, dynamic> jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      ProfileModel profile = ProfileModel.fromJson(jsonData);
      return [profile];
    } else {
      throw Exception();
    }
  }

  Future updateProfile(ProfileModel profileModel) async {
    String url = ApiConstant.UPDATE_USER;
    Map<String, dynamic> body = profileModel.toJson();
    http.Response response =
        await UserClient.instance.doUpdateProfile(url, body);
    // print("updateProfile main repo body ==> ${response.body}");
    dynamic jsonResponse = jsonDecode(response.body);
    dynamic jsonData=jsonResponse['user'];
    String message = '';
    if (jsonResponse['errors'] != null) {
      Map<String, dynamic> errors = jsonResponse['errors'];
      String fieldName = errors.keys.first;
      String errorValue = errors[fieldName][0];
      message = '$fieldName $errorValue';
    }
    if (response.statusCode == 200) {
      await hiveStore.updateSession(
        email: jsonData["email"],
        userName: jsonData["username"],
        bio: jsonData["bio"],
        image: jsonData["image"],
        token: jsonData["token"],
      );
      return response.body;
    } else if (response.statusCode == 403) {
      throw message;
    } else {
      throw message;
    }
  }

  Future changePassword(ProfileModel profileModel) async {
    String url = ApiConstant.UPDATE_USER;
    Map<String, dynamic> body = profileModel.toJson();
    http.Response response =
        await UserClient.instance.doChangePassword(url, body);
    // print("password main repo body ==> ${response.body}");
    dynamic jsonData = jsonDecode(response.body);
    String message = '';
    if (jsonData['errors'] != null) {
      Map<String, dynamic> errors = jsonData['errors'];
      String fieldName = errors.keys.first;
      String errorValue = errors[fieldName][0];
      message = '$fieldName $errorValue';
    }
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 403) {
      throw message;
    } else {
      throw message;
    }
  }

  Future fetchAllTags() async {
    String url = ApiConstant.ALL_POPULAR_TAGS;
    http.Response response = await UserClient.instance.doGet(url);
    // Map<String, dynamic> jsonData = json.decode(response.body);
    // if (response.statusCode == 401) {}
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body)["tags"];
      List<String> tagsList = List.from(jsonData.map((tagData) {
        return tagData.toString();
      }));
      return tagsList;
    } else {
      throw Exception("Failed to fetch tags");
    }
  }

  Future fetchSearchTags(String title) async {
    Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
    String url = ApiConstant.ARTICLE_BY_TAG + title;
    http.Response response = await UserClient.instance.doGet(url);
    Map<String, dynamic> jsonData = json.decode(response.body);
    // print(totalCount);
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

  Future likeArticle(String slug) async {
    Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
    String url = ApiConstant.LIKE_ARTICLE + slug + "/favorite";
    // print(url);
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer ${detailModel!.values.first.token}"
      },
    );
    print(response.body);
    print(detailModel.values.first.token);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to like article');
    }
  }

  Future removeLikeArticle(String slug) async {
    String url = ApiConstant.LIKE_ARTICLE + slug + "/favorite";
    // print(url);
    http.Response response = await UserClient.instance.doDelete(url);
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to unlike article');
    }
  }

  Future followUser(String slug) async {
    Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
    String url = ApiConstant.FOLLOW_USER + slug + "/follow";
    // print(url);
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer ${detailModel!.values.first.token}"
      },
    );
    print(response.body);
    print(detailModel.values.first.token);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to follow user');
    }
  }

  Future unFollowUser(String username) async {
    String url = ApiConstant.FOLLOW_USER + username + "/follow";
    // print(url);
    http.Response response = await UserClient.instance.doDelete(url);
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
        'Failed to unfollow user',
      );
    }
  }
}
