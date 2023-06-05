// import 'dart:convert';
// import 'package:conduit/config/constant.dart';
// import 'package:conduit/config/hive_store.dart';
// import 'package:conduit/model/profile_model.dart';
// import 'package:conduit/model/user_model.dart';
// import 'package:hive_flutter/adapters.dart';
// import "package:http/http.dart" as http;

// abstract class ProfileRepo {
//   Future<List<ProfileModel>> getProfileData();
// }

// // class ProfileRepoImpl extends ProfileRepo {
// //   @override
// //   Future<List<ProfileModel>> getProfileData() async {
// //     Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
// //     String url = ApiConstant.PROFILE + "/${detailModel!.values.last.userName}";
// //     http.Response response = await http.get(
// //       Uri.parse(url),
// //       headers: {
// //         "content-type": "application/json",
// //         "Authorization": "Bearer ${detailModel.values.first.token}"
// //       },
// //     );
// //     Map<String, dynamic> jsonData = json.decode(response.body);
// //     if (response.statusCode == 200) {
// //       List<dynamic> data = jsonData["profile"];
// //       List<ProfileModel> s = List<ProfileModel>.from(
// //         data.map(
// //           (e) => ProfileModel.fromJson(e as Map<String, dynamic>),
// //         ),
// //       );
// //       return s;
// //     } else {
// //       throw Exception();
// //     }
// //     // if (response.statusCode == 200) {
// //     //   Map<String, dynamic> jsonData = json.decode(response.body);
// //     //   dynamic profileData = jsonData["profile"];
// //     //   ProfileModel profile = ProfileModel.fromJson(profileData);
// //     //   print(profile.username);
// //     //   print(profile.bio);
// //     //   print(profile.image);
// //     //   print(profile.following);
// //     //   return [profile];
// //     // } else {
// //     //   throw Exception();
// //     // }
// //   }
// //  }
// class ProfileRepoImpl extends ProfileRepo {
//   @override
//   Future<List<ProfileModel>> getProfileData() async {
//     Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
//     String url = ApiConstant.PROFILE + "/${detailModel!.values.last.userName}";
//     http.Response response = await http.get(
//       Uri.parse(url),
//       headers: {
//         "content-type": "application/json",
//         "Authorization": "Bearer ${detailModel.values.first.token}"
//       },
//     );
//     Map<String, dynamic> jsonData = json.decode(response.body);
//     if (response.statusCode == 200) {
//       ProfileModel profile = ProfileModel.fromJson(jsonData);
//       return [profile]; // Wrap the profile in a list and return
//     } else {
//       throw Exception();
//     }
//   }
// }
