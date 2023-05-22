import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStore {
  final PublishSubject<bool> _isSessionValid = PublishSubject();
  Stream<bool> get isSessionValid => _isSessionValid.stream;
// Store data 
  Future<void> storeSlug(String slug) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("slug", slug);
  }
  Future<void> storeCommentId(int commentId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("commentId", commentId);
  }
// get data 
  Future<Map<String, dynamic>> getSlug() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {};
    data['slug'] = pref.getString("slug");
    return data;
  }
  Future<Map<String, dynamic>> getCommentId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {};
    data['commentId'] = pref.getString("commentId");
    return data;
  }
// remove data
  void removeSlug() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('slug');
  }
  void removeCommentId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('commentId');
  }
}

SharedPreferencesStore sharedPreferencesStore = SharedPreferencesStore();
