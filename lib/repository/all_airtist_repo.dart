import 'dart:convert';

import 'package:conduit/config/constant.dart';
import 'package:conduit/model/all_artist_model.dart';
import 'package:http/http.dart' as http;

abstract class AllArticlesRepo {
  Future<List<AllArticlesModel>> getAllArticlesData();
}

class AllArticlesImpl extends AllArticlesRepo {
  @override
  Future<List<AllArticlesModel>> getAllArticlesData() async {
    String url = ApiConstant.ALL_Articles;
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

      List<AllArticlesModel> s =
         List.from((data).map((e) => AllArticlesModel.fromJson(e)));
      return s;
    } else {
      throw Exception();
    }
  }
}
