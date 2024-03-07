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
    // print(response.body);
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
    // print(body);
    dynamic jsonData = jsonDecode(response.body);
    String message = '';
    if (jsonData['errors'] != null) {
      Map<String, dynamic> errors = jsonData['errors'];
      String fieldName = errors.keys.first;
      String errorValue = errors[fieldName][0];
      // Construct the error message with the field name
      message = '$fieldName $errorValue';
    }
    // print(message);
    if (response.statusCode == 200) {
      return jsonData;
    } else {
      throw message;
    }
  }
}
