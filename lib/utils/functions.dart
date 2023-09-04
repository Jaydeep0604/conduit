import 'package:conduit/config/hive_store.dart';
import 'package:conduit/ui/login/login_screen.dart';
import 'package:flutter/cupertino.dart';

class ConduitFunctions {
  @override
  static Future<void> logOut(BuildContext context) async {
    await hiveStore.logOut();
    await hiveStore.init();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) {
        return LoginScreen();
      }),
    );
  }
  
}
