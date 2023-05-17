import 'dart:convert';
import 'dart:ffi';

import 'package:conduit/config/constant.dart';
import 'package:conduit/config/hive_store.dart';
import 'package:conduit/model/all_artist_model.dart';
import 'package:conduit/model/new_article_model.dart';
import 'package:conduit/model/user_model.dart';
import 'package:conduit/services/auth_client.dart';
import 'package:conduit/services/user_client.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;

abstract class AllArticlesRepo {
  Future<List<AllArticlesModel>> getAllArticlesData();
  Future<dynamic> addNewArticle(NewArticleModel newArticleModel);
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
    if (response.statusCode == 200) {
      dynamic jsonData = jsonDecode(response.body);
      return jsonData;
    } else if (response.statusCode == 403) {
      throw "Something wantv wrong please try agian later.";
    } else {
      throw response.body;
    }
  }
}
