import 'dart:convert';
import 'package:conduit/config/constant.dart';
import 'package:conduit/model/user_data_model.dart';
import 'package:conduit/services/user_client.dart';
import "package:http/http.dart" as http;


abstract class UserRepo {
  Future<UserData> getUserProfileData();
}

class UserRepoImpl extends UserRepo {
  // EncodeDecode encodeDecode = EncodeDecode();
  @override
  Future<UserData> getUserProfileData() async {
    String url = ApiConstant.PROFILE;
    http.Response response = await UserClient.instance.doGet(url);    
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception();
    }

    // http.Response response = await UserClient.instance.doPost(url, {});
    // if (response.statusCode == 200) {
    //   dynamic jsonData = jsonDecode(response.body);
    //   if (jsonData['success_code'] == 200) {
    //     dynamic data = jsonDecode(encodeDecode.decode(jsonData['data']));
    //     return UserData.fromJson(data);
    //   } else {
    //     throw Exception(jsonDecode(response.body)['message']);
    //   }
    // } else {
    //   throw Exception(jsonDecode(response.body)['message']);
    // }
  }
}
