import 'package:conduit/model/user_model.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rxdart/subjects.dart';

class HiveStore {
  final userDetailKey = "user";
  final userId = "userId";
  final tokenId = "tokenId";
  final tokenKey = "token";

  UserAccessData? userAccessData;

  final PublishSubject<bool> _isSessionValid = PublishSubject<bool>();

  Stream<bool> get isSessionValid => _isSessionValid.stream;

  init() async {
    await Hive.openBox<UserAccessData>(userDetailKey);
    await Hive.openBox<UserAccessData>(userId);
    await Hive.openBox<String>(tokenId);
    await Hive.openBox<String>(tokenKey);
  }

  Future logOut() async {
    try {
      await Hive.deleteBoxFromDisk(hiveStore.userDetailKey);
    } catch (e) {}
    try {
      await Hive.deleteBoxFromDisk(hiveStore.userId);
    } catch (e) {}
  }

  Future delteToken() async {
    try {
      await Hive.deleteBoxFromDisk(hiveStore.tokenKey);
    } catch (e) {}
    try {
      await Hive.deleteBoxFromDisk(hiveStore.tokenId);
    } catch (e) {}
  }

  Future<bool> isSession() async {
    try {
      bool isBoxOpened = await Hive.boxExists(userDetailKey);
      if (isBoxOpened) {
        Box<UserAccessData> userBox1 = await Hive.openBox(userDetailKey);

        // Box<UserAccessData> userBox = Hive.box(userKey);
        UserAccessData? userAccessData = userBox1.get(userId);
        if (userAccessData != null) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return true;
    }
  }

  Future<bool> isTokenSession() async {
    try {
      bool isBoxOpened = await Hive.boxExists(tokenKey);
      if (isBoxOpened) {
        Box<String> userBox1 = await Hive.openBox(tokenKey);

        // Box<UserAccessData> userBox = Hive.box(userKey);
        String? token = userBox1.get(tokenId);
        if (token != null) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return true;
    }
  }

  Future<bool> openSession(UserAccessData userAccessData) async {
    Box<UserAccessData> userBox = Hive.box<UserAccessData>(userDetailKey);
    userBox.put(userId, userAccessData);
    // DownloadService.instance.changeScheduledTask(userData.accessToken);
    // downloadStore.updateDownloadTaskWithAccessToken(userData.accessToken);

    if (userBox.containsKey(userId)) {
      _isSessionValid.add(true);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> openTokenSession(String token) async {
    Box<String> userTokenBox = Hive.box<String>(token);
    userTokenBox.put(tokenId, token);
    // DownloadService.instance.changeScheduledTask(userData.accessToken);
    // downloadStore.updateDownloadTaskWithAccessToken(userData.accessToken);

    if (userTokenBox.containsKey(tokenId)) {
      _isSessionValid.add(true);
      return true;
    } else {
      return false;
    }
  }

  Future<Box<UserAccessData>?> isExistUserAccessData() async {
    try {
      bool isBoxOpend = await Hive.boxExists(userDetailKey);
      if (isBoxOpend) {
        Box<UserAccessData> detailBox = Hive.box(userDetailKey);
        return detailBox;
      }
      return null;
    } on HiveError {
      return null;
    }
  }

  Future<Box<String>?> isExistTokenData() async {
    try {
      bool isBoxOpend = await Hive.boxExists(tokenKey);
      if (isBoxOpend) {
        Box<String> detailBox = Hive.box(tokenKey);
        return detailBox;
      }
      return null;
    } on HiveError {
      return null;
    }
  }

  // UserAccessData? getUserAccessData() {
  //   Box<UserAccessData> userDetailBox = Hive.box<UserAccessData>(userDetailKey);
  //   UserAccessData? data = userDetailBox.get(userId);
  // }

  // updateUserData(UserAccessData userAccessData) {
  //   Box<UserAccessData> userDataBox = Hive.box<UserAccessData>(userDetailKey);
  //   userDataBox.put(userId, userAccessData);
  // }

  // removeUserData() async {
  //   Box<UserAccessData>? userDataBox = await isExistUserAccessData();
  //   userDataBox?.close();
  // }

  clossSession() async {
    _isSessionValid.sink.add(false);
  }
}

HiveStore hiveStore = HiveStore();
