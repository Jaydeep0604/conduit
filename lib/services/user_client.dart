import 'dart:convert';
import 'package:conduit/config/cHiveStore.dart';
import 'package:conduit/config/constant.dart';
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
    Box<UserAccessData>? userData = await cHiveStore.isExistUserBox();

    if (userData == null) {
      return http.Response("{'msg':'No user found'}", 404);
    }
    Map<String, String> head = {
      "content-type": "application/json",
      "Authorization": "Bearer ${ApiConstant.TOKEN}"
      // "Authorization": "Bearer ${userData.values.last.token}"
    };
    // ${userData.values.last.token
    if (header != null) {
      head.addAll(header);
    }

    try {
      http.Response response = await http.get(Uri.parse(url), headers: head);
      print("${response.body}");
      dynamic jsonData = jsonDecode(response.body);
      if (response.statusCode != 403 && response.statusCode != 401) {
        return response;
      } else {
        throw UnAuthorizedException(
            message: jsonData['message'] ?? "Session Expired..!".toString(),
            statusCode: response.statusCode);
      }
    } on UnAuthorizedException catch (e) {
      cHiveStore.clossSession();
      return http.Response('{"message":"${e.message}"}', e.statusCode);
    }
  }

  // Future<http.Response> doPost(String url, Map<String, dynamic> body,
  //     {Map<String, String>? header}) async {
  //   Box<UserAccessData>? userData = await cHiveStore.isExistUserBox();

  //   if (userData == null) {
  //     return http.Response("{'msg':'No user found'}", 404);
  //   }
  //   Map<String, String> head = {
  //     "content-type": "application/json",
  //     "Authorization": "Bearer ${userData.values.last.token} "
  //   };
  //   print("Featured data :  ${userData.values.last.token}");
  //   if (header != null) {
  //     head.addAll(header);
  //   }

  //   dynamic bod = jsonEncode({"info": encodeDecode.encode(json.encode(body))});

  //   try {
  //     http.Response response = await http.post(Uri.parse(url),
  //         body: jsonEncode({"info": encodeDecode.encode(json.encode(body))}),
  //         headers: head);
  //     print("${response.body}");
  //     dynamic jsonData = jsonDecode(response.body);
  //     if (response.statusCode != 403 && response.statusCode != 401) {
  //       return response;
  //     } else {
  //       throw UnAuthorizedException(
  //           message: jsonData['message'] ?? "Session Expired..!".toString(),
  //           statusCode: response.statusCode);
  //     }
  //   } on UnAuthorizedException catch (e) {
  //     ksHiveStore.clossSession();
  //     return http.Response('{"message":"${e.message}"}', e.statusCode);
  //   }
  // }

  // Future<http.Response> doDelete(String url, Map<String, dynamic> body,
  //     {Map<String, String>? header}) async {
  //   Box<UserAccessData>? userData = await ksHiveStore.isExistUserBox();

  //   if (userData == null) {
  //     return http.Response("{'msg':'No user found'}", 404);
  //   }

  //   Map<String, String> head = {
  //     "content-type": "application/json",
  //     "Authorization": "Bearer ${userData.values.last.accessToken} "
  //   };
  //   if (header != null) {
  //     head.addAll(header);
  //   }

  //   dynamic bod = jsonEncode({"info": encodeDecode.encode(json.encode(body))});

  //   try {
  //     http.Response response = await http.delete(Uri.parse(url),
  //         body: jsonEncode({"info": encodeDecode.encode(json.encode(body))}),
  //         headers: head);
  //     if (response.statusCode != 403 && response.statusCode != 401) {
  //       return response;
  //     } else {
  //       throw UnAuthorizedException(
  //           message: response.statusCode.toString(),
  //           statusCode: response.statusCode);
  //     }
  //   } on UnAuthorizedException catch (e) {
  //     ksHiveStore.clossSession();
  //     return http.Response(e.message ?? "", e.statusCode);
  //   }
  // }
}
