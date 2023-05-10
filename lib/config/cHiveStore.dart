import 'package:conduit/model/user_data_model.dart';
import 'package:conduit/model/user_model.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import "package:hive/hive.dart";
// import 'package:shared_preferences/shared_preferences.dart';

  class CHiveStore {
  final userKey = "user";
  final userStoreKey = "userStoreKey";
  // final userStoreID = "userStoreID";
  final userId = "userId";
  // final userAccessToken = "access_token";
  // final albumModelBox = "albumModelKey";
  // final genreModelBox = "genreModelBox";
  // final AllArtistModelBox = "AllArtistModelBox";
  // final currentAlbumKey = "currentalbumkey";
  // final currentGenreKey = "currentGenreKey";
  // final currentArtistKey = "currentArtistKey";

  UserAccessData? userAccessData;

  final PublishSubject<bool> _isSessionValid = PublishSubject<bool>();

  Stream<bool> get isSessionValid => _isSessionValid.stream;

  // setCurrentAlbum(AlbumModel albumModel) async {
  //   Box<AlbumModel> albumBox = Hive.box(albumModelBox);
  //   await albumBox.clear();
  //   await albumBox.put(currentAlbumKey, albumModel);
  // }

  // AlbumModel? getCurrentAlbum() {
  //   Box<AlbumModel> albumBox = Hive.box(albumModelBox);
  //   return albumBox.get(currentAlbumKey);
  // }

  // setCurrentGenre(GenerModel generModel) async {
  //   Box<GenerModel> generBox = Hive.box(genreModelBox);
  //   await generBox.clear();
  //   await generBox.put(currentGenreKey, generModel);
  // }

  // setCurrentArtist(AllArtistModel AllArtistModel) async {
  //   Box<AllArtistModel> artistBox = Hive.box(AllArtistModelBox);
  //   await artistBox.clear();
  //   await artistBox.put(currentArtistKey, AllArtistModel);
  // }

  init() async {
    await Hive.openBox<UserAccessData>(userKey);
    await Hive.openBox<UserAccessData>(userId);
    await Hive.openBox<UserAccessData>(userStoreKey);
    // await Hive.openBox<UserData>(userStoreKey);
    // await Hive.openBox<AlbumModel>(albumModelBox);
    // await Hive.openBox<GenerModel>(genreModelBox);
    // await Hive.openBox<AllArtistModel>(AllArtistModelBox);
  }

  // storeUserAccessDataInShared(String accessToken, String userid) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(userId, userid);
  //   await prefs.setString(userAccessToken, accessToken);
  // }

  // Future<Map<String, dynamic>> getUserAccessDatainShared() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return {
  //     "user_id": prefs.getString(userId),
  //     "access_token": prefs.getString(userAccessToken)
  //   };
  // }

  // removeUserAccessDataInShared() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.containsKey(userId)) {
  //     await prefs.remove(userId);
  //   }
  //   if (prefs.containsKey(userAccessToken)) {
  //     await prefs.remove(userAccessToken);
  //   }
  // }

  Future logOut() async {
    // try {
    //   await Hive.deleteBoxFromDisk(cPlaylistStore.playListStoreKey);
    // } catch (e) {}
    // try {
    //   await Hive.deleteBoxFromDisk(cHiveStore.userKey);
    // } catch (e) {}
    // try {
    //   await Hive.deleteBoxFromDisk(cHiveStore.userKey);
    // } catch (e) {}
    // try {
    //   await Hive.deleteBoxFromDisk(cHiveStore.userStoreKey);
    // } catch (e) {}
    // try {
    //   await Hive.deleteBoxFromDisk(cHiveStore.albumModelBox);
    // } catch (e) {}
    // try {
    //   await Hive.deleteBoxFromDisk(cHiveStore.genreModelBox);
    // } catch (e) {}
    // try {
    //   await Hive.deleteBoxFromDisk(cHiveStore.AllArtistModelBox);
    // } catch (e) {}
    // try {
    //   await Hive.deleteBoxFromDisk(cLikedLongStore.likeSongStoreKey);
    // } catch (e) {}
    // try {
    //   await Hive.deleteBoxFromDisk(cLikedAlbumStore.likeAlbumStoreKey);
    // } catch (e) {}
    // try {
    //   await Hive.deleteBoxFromDisk(cLikedArtistStore.likeArtistStoreKey);
    // } catch (e) {}
    // try {
    //   await Hive.deleteBoxFromDisk(cLikedPlaylistStore.likePlaylistStoreKey);
    // } catch (e) {}
    // try {
    //   await Hive.deleteBoxFromDisk(cFavGenerStore.faveGenerStoreKey);
    // } catch (e) {}
    //await HydratedBloc.storage.clear();

    // storage.clear();
  }

  initUserAccessData(UserAccessData userAccessData) {
    userAccessData = userAccessData;
  }

  Future<bool> openSession(UserAccessData userData) async {
    Box<UserAccessData> userBox = Hive.box<UserAccessData>(userKey);
    userBox.put(userId, userData);
    // DownloadService.instance.changeScheduledTask(userData.accessToken);
    // downloadStore.updateDownloadTaskWithAccessToken(userData.accessToken);

    if (userBox.containsKey(userId)) {
      _isSessionValid.add(true);
      return true;
    } else {
      return false;
    }
  }

  void dispose() {
    _isSessionValid.close();
    
  }

  void restoreSession() async {
    bool session = await isSession();
    if (session) {
      _isSessionValid.sink.add(true);
    } else {
      _isSessionValid.sink.add(false);
    }
  }

  clossSession() async {
    _isSessionValid.sink.add(false);
  }

  Future<bool> isSession() async {
    try {
      bool isBoxOpened = await Hive.boxExists(userKey);
      if (isBoxOpened) {
        Box<UserAccessData> userBox1 = await Hive.openBox(userKey);

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

  Future<Box<UserAccessData>?> isExistUserBox() async {
    try {
      bool isBoxOpened = await Hive.boxExists(userKey);
      if (isBoxOpened) {
        Box<UserAccessData> userBox = Hive.box(userKey);
        return userBox;
      }
      return null;
    } on HiveError {
      return null;
    }
  }

  // Future<Box<UserData>?> isExistUserDataBox() async {
  //   bool isBoxOpened = await Hive.boxExists(userStoreKey);
  //   if (isBoxOpened) {
  //     Box<UserData> userBox = Hive.box(userKey);
  //     return userBox;
  //   }
  //   return null;
  // }

  Future<bool> storeUserData(UserData userData) async {
    Box<UserData> userDataBox = Hive.box<UserData>(userStoreKey);
    userDataBox.put(userKey, userData);
    if (userDataBox.containsKey(userKey)) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  // UserData? getUserData() {
  //   Box<UserData> userDataBox = Hive.box<UserData>(userStoreKey);
  //   UserData? data = userDataBox.get(userKey);
  //   return data;
  // }

  // updateUserData(UserData data) {
  //   Box<UserData> userDataBox = Hive.box<UserData>(userStoreKey);
  //   userDataBox.put(userStoreID, data);
  // }

  // removeUserData() async {
  //   Box<UserData>? userDataBox = await isExistUserDataBox();
  //   userDataBox?.close();
  // }

  UserAccessData? getUserAccessData() {
    bool isOpen = Hive.isBoxOpen(userKey);
    if (!isOpen) {
      return null;
    }
    Box<UserAccessData> userAccessData = Hive.box<UserAccessData>(userKey);
    UserAccessData? accessData = userAccessData.get(userKey);
    return accessData;
  }

  initAccessUserData(UserAccessData userData) {
    userAccessData = userData;
  }

  Future<Box<T>> openBoxFromAsset<T>() async {
    var data = await rootBundle.load("assets/$userKey.hive");
    var bytes = data.buffer.asUint8List();
    return Hive.openBox<T>(userKey, bytes: bytes);
  }
}

CHiveStore cHiveStore = CHiveStore();
