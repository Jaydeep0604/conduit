import 'dart:convert';
import 'package:conduit/config/constant.dart';
import 'package:conduit/model/auth_model.dart';
import 'package:conduit/services/auth_client.dart';
import "package:http/http.dart" as http;

abstract class AuthRepo {
  Future<dynamic> register(AuthModel authModel);
  Future<dynamic> login(AuthModel authModel);
}

class AuthRepoImpl extends AuthRepo {
  @override
  Future register(AuthModel authModel) async {
    Map<String, dynamic> body = authModel.toJson();
    http.Response response =
        await AuthClient.instance.doPost(ApiConstant.REGISTER, body);
    print(response.body);
    dynamic jsonData = jsonDecode(response.body);
    String message = '';
    if (jsonData['errors'] != null) {
      Map<String, dynamic> errors = jsonData['errors'];
      if (errors.containsKey('email')) {
        String emailError = errors['email'][0];
        message += 'email $emailError';
      }
      if (errors.containsKey('username')) {
        if (message.isNotEmpty) {
          message += ', ';
        }
        String usernameError = errors['username'][0];
        message += 'username $usernameError';
      }
    }
    if (response.statusCode == 201) {
      return response;
    } else {
      throw message;
    }
  }

  @override
  Future login(AuthModel authModel) async {
    Map<String, dynamic> body = authModel.toJson();

    http.Response response =
        await AuthClient.instance.doPost(ApiConstant.LOGIN, body);
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
    print(message);
    if (response.statusCode == 200) {
      return jsonData;
    } else {
      throw message;
    }
  }
}


// @override
// Future register(AuthModel authModel) async {
//    Map<String, dynamic> body = authModel.toJson();
//   print("$body");
//   http.Response response =
//       await AuthClient.instance.doPost(ApiConstant.REGISTER,body);
//   dynamic jsonData = jsonDecode(response.body);
//   print("register $jsonData");
//   if (response.statusCode == 200) {
//     // if (jsonData['success_code'] == 200 && jsonData['success'] == true) {
//       return jsonData;
//     // } else {
//     //   throw Exception(jsonData['message']);
//     // }
//   }
//   else if(response.statusCode==422){
//     throw "$body";
//   }
//   else {
//     throw Exception(jsonData['message']);
//   }
// }

// @override
// Future login(AuthModel authModel) async {
//    Map<String, dynamic> body = authModel.toJson();
//   print("$body");
//   http.Response response =
//       await AuthClient.instance.doPost(ApiConstant.LOGIN,body);
//       print(response.body.toString());
//   if (response.statusCode == 200) {
//     print(response.body);
//     // if (jsonData['success_code'] == 200 && jsonData['success'] == true) {
//       return response.body;
//     // } else {
//     //   throw Exception(jsonData['message']);
//     // }
//   } else {
//     throw Exception("Something went wrong try again later");
//   }
// }

// class LoginRepository {
//   Future<dynamic> login(String email, String password, String userDeviceId, String fcmToken) async {
//     final url = 'https://admin.p6risk.com/public/api/login';
//     final body = {
//       'email_phone': email,
//       'password': password,
//       'user_device_id': userDeviceId,
//       'fcm_token': fcmToken,
//     };
//     final response = await http.post(Uri.parse(url), body: body);
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       if (jsonData['success_code'] == 200 && jsonData['success'] == true) {
//         return jsonData;
//       } else {
//         throw Exception(jsonData['message']);
//       }
//     } else {
//       throw Exception('Failed to login');
//     }
//   }
// }