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
  Future<List<AllArticlesModel>> getAllArticlesData();
  Future<dynamic> addNewArticle(NewArticleModel newArticleModel);
  Future<String> addComment(AddCommentModel addCommentModel);
  Future<List<CommentModel>> getComment();
  Future<int> deleteComment(int commentId);
}

class AllArticlesImpl extends AllArticlesRepo {
  @override
  Future<List<AllArticlesModel>> getAllArticlesData() async {
    String url = ApiConstant.ALL_Articles;
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

      // Construct the error message with the field name
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

  Future<String> addComment(AddCommentModel addCommentModel) async {
    String? slug;
    final pref = await sharedPreferencesStore.getSlug();
    slug = await pref['slug'];
    // String url =
    //     "https://api.realworld.io/api/articles/Creativity_Is_a_Process_Not_an_Event-179946/comments";
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

      // Construct the error message with the field name
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

  // Future<String> addComment(AddCommentModel addCommentModel) async {
  //   String? slug;
  //   final pref = await sharedPreferencesStore.getTitle();
  //   slug = await pref['slug'];
  //   String url =
  //       ApiConstant.BASE_COMMENT_URL + "/${slug}" + ApiConstant.END_COMMENT_URL;

  //   Map<String, dynamic> body = addCommentModel.toJson();
  //   http.Response response = await UserClient.instance.doPostComment(url, body);
  //   print(body);

  //   if (response.statusCode == 200) {
  //     return "Comment added successfully";
  //   } else if (response.statusCode == 403) {
  //     throw "Authorization error";
  //   } else {
  //     // Handle other errors
  //     throw "An error occurred";
  //   }
  // }

  Future<List<CommentModel>> getComment() async {
    String? slug;
    // GlobalItemDetailScreen globalItemDetailScreen = GlobalItemDetailScreen();
    // slug = await globalItemDetailScreen.allArticlesModel!.slug;
    // print("slug of globle detail screen :: $slug");
    final pref = await sharedPreferencesStore.getSlug();
    slug = await pref['slug'];
    // String url ="https://api.realworld.io/api/articles/The-Kauwa-Kaate-Fake-News-Detection-System:-Demo-135353/comments";
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

      // List<CommentModel> s = List<CommentModel>.from(
      //     data.map((e) => CommentModel.fromJson(e as Map<String, dynamic>)));

      // List<CommentModel> s =
      //     List.from((data).map((e) => CommentModel.fromJson(e)));
      return s;
    } else {
      throw Exception();
    }
  }

  // Future<int> deleteComment() async {
  //   String? slug;
  //   int? CommentId;
  //   final pref = await sharedPreferencesStore.getSlug();
  //   slug = await pref['slug'];
  //   final pref2 = await sharedPreferencesStore.getCommentId();
  //   CommentId = await pref['commentId'];
  //   String url = ApiConstant.BASE_COMMENT_URL +
  //       "/${slug}" +
  //       ApiConstant.END_COMMENT_URL +
  //       "/${CommentId}";
  //   print(url);
  //   Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
  //   http.Response response = await http.get(
  //     Uri.parse(url),
  //     headers: {
  //       "content-type": "application/json",
  //       "Authorization": "Bearer ${detailModel!.values.first.token}"
  //     },
  //   );
  //   Map<String, dynamic> jsonData = json.decode(response.body);

  //   if (response.statusCode == 200) {
  //     int data = 1;
  //     // List<dynamic> data = jsonData["comments"];
  //     // print(data);
  //     // List<CommentModel> s = List<CommentModel>.from(
  //     //     data.map((e) => CommentModel.fromJson(e as Map<String, dynamic>)));

  //     return data;
  //   } else {
  //     throw Exception();
  //   }
  // }
  Future<int> deleteComment(int commentId) async {
    Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
    String? slug;
    final pref = await sharedPreferencesStore.getSlug();
    slug = await pref['slug'];
    // final pref2 = await sharedPreferencesStore.getCommentId();
    // commentId = await pref['commentId'];

    // Construct the URL for the delete request
    String url = ApiConstant.BASE_COMMENT_URL +
        "/${slug}" +
        ApiConstant.END_COMMENT_URL +
        "/${commentId}";

    // Perform the delete request
    http.Response response = await http.delete(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer ${detailModel!.values.first.token}"
      },
    );

    // Check the response status code
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw Exception('Failed to delete comment');
    }
  }
}
