import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStore {
  final PublishSubject<bool> _isSessionValid = PublishSubject();
  Stream<bool> get isSessionValid => _isSessionValid.stream;

  Future<void> storeSlug(String title) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("title", title);
  }

  Future<Map<String, dynamic>> getTitle() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {};
    data['title'] = pref.getString("title");
    return data;
  }

  void logOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('title');
  }
}

SharedPreferencesStore sharedPreferencesStore = SharedPreferencesStore();
