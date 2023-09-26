import 'dart:convert';
import 'package:conduit/config/hive_store.dart';
import 'package:conduit/model/new_article_model.dart';
import 'package:conduit/model/profile_model.dart';
import 'package:conduit/model/user_model.dart';
import 'package:conduit/utils/c_exception.dart';
import 'package:hive/hive.dart';
import "package:http/http.dart" as http;

class UserClient {
  static final UserClient instance = UserClient._internal();
  // EncodeDecode encodeDecode = EncodeDecode();
  factory UserClient() {
    return instance;
  }

  UserClient._internal();
  
  Future<http.Response> doGet(String url, {Map<String, String>? header}) async {
    Box<UserAccessData>? userData = await hiveStore.isExistUserAccessData();
    if (userData == null) {
      return http.Response("{'msg':'No user found'}", 404);
    }
    Map<String, String> head = {
      "content-type": "application/json",
      "Authorization": "Bearer ${userData.values.last.token}"
    };
    if (header != null) {
      head.addAll(header);
    }
    return http.get(Uri.parse(url), headers: head);
  }

  Future<http.Response> doPost(String url, Map<String, dynamic> body,
      {Map<String, String>? header}) async {
    Box<UserAccessData>? userData = await hiveStore.isExistUserAccessData();
    if (userData == null) {
      return http.Response("{'msg':'No user found'}", 404);
    }
    Map<String, String> head = {
      "content-type": "application/json",
      "Authorization": "Bearer ${userData.values.last.token}"
    };
    if (header != null) {
      head.addAll(header);
    }

    try {
      http.Response response =
          await http.post(Uri.parse(url), body: body, headers: head);
      if (response.statusCode != 403) {
        return response;
      } else {
        throw UnAuthorizedException(
            message: response.statusCode.toString(),
            statusCode: response.statusCode);
      }
    } on UnAuthorizedException catch (e) {
      userData.close();
      return http.Response(e.message ?? "", e.statusCode);
    }
  }

   Future<http.Response> doDelete(String url, {Map<String, String>? header}) async {
    Box<UserAccessData>? userData = await hiveStore.isExistUserAccessData();
    if (userData == null) {
      return http.Response("{'msg':'No user found'}", 404);
    }
    Map<String, String> head = {
      "content-type": "application/json",
      "Authorization": "Bearer ${userData.values.last.token}"
    };
    if (header != null) {
      head.addAll(header);
    }
    return http.delete(Uri.parse(url), headers: head);
  }

  Future<http.Response> doPostArticle(String url, Map<String, dynamic> body,
      {Map<String, String>? header}) async {
    Box<UserAccessData>? userData = await hiveStore.isExistUserAccessData();

    if (userData == null) {
      return http.Response("{'msg':'No user found'}", 404);
    }

    Map<String, String> head = {
      "content-type": "application/json",
      "Authorization": "Bearer ${userData.values.last.token}"
    };

    if (header != null) {
      head.addAll(header);
    }

    ArticleModel newArticleModel = ArticleModel(
      article: Article(
        title: body.values.first["title"],
        description: body.values.first["description"],
        body: body.values.first["body"],
        tagList: body.values.first["tagList"],
      ),
    );

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(newArticleModel.toJson()),
        headers: head,
      );

      dynamic jsonData = jsonDecode(response.body);
      if (response.statusCode != 403 && response.statusCode != 401) {
        return response;
      } else {
        throw UnAuthorizedException(
          message: jsonData['message'] ?? "Session Expired..!".toString(),
          statusCode: response.statusCode,
        );
      }
    } on UnAuthorizedException catch (e) {
      hiveStore.clossSession();
      return http.Response('{"message":"${e.message}"}', e.statusCode);
    }
  }

  Future<http.Response> doUpdateArticle(String url, Map<String, dynamic> body,
      {Map<String, String>? header}) async {
    Box<UserAccessData>? userData = await hiveStore.isExistUserAccessData();
    if (userData == null) {
      return http.Response("{'msg':'No user found'}", 404);
    }

    Map<String, String> head = {
      "content-type": "application/json",
      "Authorization": "Bearer ${userData.values.last.token}"
    };

    if (header != null) {
      head.addAll(header);
    }

    ArticleModel newArticleModel = ArticleModel(
      article: Article(
        title: body.values.first["title"],
        description: body.values.first["description"],
        body: body.values.first["body"],
        tagList: body.values.first["tagList"],
      ),
    );
    try {
      http.Response response = await http.put(
        Uri.parse(url),
        body: jsonEncode(newArticleModel.toJson()),
        headers: head,
      );

      dynamic jsonData = jsonDecode(response.body);
      if (response.statusCode != 403 && response.statusCode != 401) {
        return response;
      } else {
        throw UnAuthorizedException(
          message: jsonData['message'] ?? "Session Expired..!".toString(),
          statusCode: response.statusCode,
        );
      }
    } on UnAuthorizedException catch (e) {
      hiveStore.clossSession();
      return http.Response('{"message":"${e.message}"}', e.statusCode);
    }
  }

  Future<http.Response> doPostComment(String url, Map<String, dynamic> body,
      {Map<String, String>? header}) async {
    Box<UserAccessData>? userData = await hiveStore.isExistUserAccessData();
    if (userData == null) {
      return http.Response("{'msg':'No user found'}", 404);
    }

    Map<String, String> head = {
      "content-type": "application/json",
      "Authorization": "Bearer ${userData.values.last.token}"
    };

    if (header != null) {
      head.addAll(header);
    }


    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: head,
      );

      dynamic jsonData = jsonDecode(response.body);
      if (response.statusCode != 403 && response.statusCode != 401) {
        return response;
      } else {
        throw UnAuthorizedException(
          message: jsonData['message'] ?? "Session Expired..!".toString(),
          statusCode: response.statusCode,
        );
      }
    } on UnAuthorizedException catch (e) {
      hiveStore.clossSession();
      return http.Response('{"message":"${e.message}"}', e.statusCode);
    }
  }

  Future<http.Response> doUpdateProfile(String url, Map<String, dynamic> body,
      {Map<String, String>? header}) async {
    Box<UserAccessData>? userData = await hiveStore.isExistUserAccessData();
    // print("TOKEN IS :: ${userData!.values.last.token}");
    if (userData == null) {
      return http.Response("{'msg':'No user found'}", 404);
    }
    Map<String, String> head = {
      "content-type": "application/json",
      "Authorization": "Bearer ${userData.values.last.token}"
    };

    if (header != null) {
      head.addAll(header);
    }
    ProfileModel profileModel = ProfileModel(
      user: User(
        email: body.values.first['email'],
        username: body.values.first["username"],
        bio: body.values.first["bio"],
        image: body.values.first['image'],
        password: body.values.first['password'],
      ),
    );
    try {
      http.Response response = await http.put(
        Uri.parse(url),
        body: jsonEncode(profileModel.toJson()),
        headers: head,
      );
      // print("profile updated data is =====> ${response.body}");
      dynamic jsonData = jsonDecode(response.body);
      if (response.statusCode != 403 && response.statusCode != 401) {
        return response;
      } else {
        throw UnAuthorizedException(
          message: jsonData['message'] ?? "Session Expired..!".toString(),
          statusCode: response.statusCode,
        );
      }
    } on UnAuthorizedException catch (e) {
      hiveStore.clossSession();
      return http.Response('{"message":"${e.message}"}', e.statusCode);
    }
  }

  Future<http.Response> doChangePassword(String url, Map<String, dynamic> body,
      {Map<String, String>? header}) async {
    Box<UserAccessData>? userData = await hiveStore.isExistUserAccessData();
    // print("TOKEN IS :: ${userData!.values.last.token}");
    if (userData == null) {
      return http.Response("{'msg':'No user found'}", 404);
    }
    Map<String, String> head = {
      "content-type": "application/json",
      "Authorization": "Bearer ${userData.values.last.token}"
    };
    if (header != null) {
      head.addAll(header);
    }
    ProfileModel profileModel = ProfileModel(
      user: User(
        password: body.values.first['password'],
      ),
    );

    try {
      http.Response response = await http.put(
        Uri.parse(url),
        body: jsonEncode(profileModel.toJson()),
        headers: head,
      );
      // print("password updated data is =====> ${response.body}");
      dynamic jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return response;
      } else {
        throw UnAuthorizedException(
          message: jsonData['message'] ?? "Session Expired..!".toString(),
          statusCode: response.statusCode,
        );
      }
    } on UnAuthorizedException catch (e) {
      hiveStore.clossSession();
      return http.Response('{"message":"${e.message}"}', e.statusCode);
    }
  }
}
