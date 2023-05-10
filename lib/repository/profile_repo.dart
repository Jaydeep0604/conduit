import 'dart:convert';
import 'package:conduit/config/constant.dart';
import 'package:conduit/model/auth_model.dart';
import "package:http/http.dart" as http;

abstract class ProfileRepo {
  // Future List<AuthModel> getUserProfileData();
  // getUserProfileData();
  Future<List<AuthModel>> getUserProfileData();
  
}

class ProfileRepoImpl extends ProfileRepo {
  // @override
  //  Future<List<AuthModel>> getUserProfileData() async {
  //   http.Response response =
  //       await UserClient.instance.doGet(ApiConstant.PROFILE);
  //   if (response.statusCode == 200) {
  //   // Map<String,dynamic> jsonData=jsonDecode(response.body);
  //   //   Map<String,dynamic> data=jsonData['user'];
  //   //   print(data);
  //   //     return data;
  //   dynamic data = jsonDecode(response.body);
  //   } else {
  //     throw Exception("Something went wrong try again later");
  //   }
  // }
  @override
  Future<List<AuthModel>> getUserProfileData() async {
    String url = ApiConstant.PROFILE;
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer ${ApiConstant.TOKEN}"
      },
    );
    Map<String,dynamic>jsonData=json.decode(response.body);
    // dynamic jsonData =jsonDecode(response.body);

    if (response.statusCode == 200) {
      // dynamic data = jsonDecode(jsonData);
      List<dynamic> data = jsonData["articles"];

      List<AuthModel> s =
         List.from((data).map((e) => AuthModel.fromJson(e)));
      return s;
    } else {
      throw Exception();
    }
  }
  // Future<AuthModel> getUserProfileData() async {
  //   String url = ApiConstant.PROFILE;
  //   http.Response response = await http.get(Uri.parse(url), headers: {
  //     "content-type": "application/json",
  //     "Authorization": "Bearer ${ApiConstant.TOKEN}"
  //   });
  //   Map<String, dynamic> jsonData = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     List<dynamic> data = jsonData['user'];
  //     // // List<AuthModel> s = List.from((data).map((e) => AuthModel.fromJson(e)));
  //     // return authModel.fromJson(jsonData);
  //     // Map<String, dynamic> jsonData = jsonDecode(response.body);
  //     // Map<String, dynamic> s = jsonData['user'];
  //     List<AuthModel> s =
  //        List.from((data).map((e) => AuthModel.fromJson(e)));
  //     // print(s);
  //     return s;
  //   } else {
  //     throw Exception("Something went wrong try again later");
  //   }
  // }
}
