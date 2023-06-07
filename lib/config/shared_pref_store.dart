import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedStore {
  final PublishSubject<bool> _isSessionValid = PublishSubject();
  Stream<bool> get isSessionValid => _isSessionValid.stream;

  Future<void> openSession(
    String token,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<Map<String, dynamic>> getAllData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {};
    data['token'] = pref.getString("token");
    return data;
  }

  void logOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('token');
  }
}

SharedStore sharedStore = SharedStore();
