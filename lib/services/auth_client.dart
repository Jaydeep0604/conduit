import 'dart:convert';
import "package:http/http.dart" as http;

class AuthClient {
  static final AuthClient instance = AuthClient._internal();
  factory AuthClient() {
    return instance;
  }

  AuthClient._internal();
  doGet(String url, Map<String, String> header) {
    return http.get(Uri.parse(url), headers: header);
  }

  Future<http.Response> doPost(String url, Map<String, dynamic> body,
      {Map<String, String>? header}) {
    Map<String, String> head = {"content-type": "application/json"};
    if (header != null) {
      head.addAll(header);
    }
    // String data = (json.encode(body));
    return http.post(Uri.parse(url),
        body: jsonEncode({"user": body}), headers: head);
  }

  Future<http.Response> doAuth(String url, Object body,
      {Map<String, String>? header}) {
    Map<String, String> head = {
      "content-type": "application/json"
      // "content-type": "application/x-www-form-urlencoded; charset=UTF-8"
    };
    if (header != null) {
      head.addAll(header);
    }
    return http.post(Uri.parse(url), body: jsonEncode(body), headers: head);
  }
}
