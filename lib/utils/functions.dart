import 'package:conduit/config/hive_store.dart';
import 'package:conduit/ui/login/login_screen.dart';
import 'package:conduit/utils/message.dart';
import 'package:flutter/material.dart';

class ConduitFunctions {
  @override
  static Future<void> logOut(BuildContext context) async {
    await hiveStore.logOut();
    await hiveStore.init();

    Future.delayed(Duration(microseconds: 200)).then((value) async {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, LoginScreen.loginUrl);
      // Navigator.of(context)
      //     .popAndPushNamed(LoginScreen.loginUrl);
      // globalNavigationKey.currentState
      //     ?.pushNamedAndRemoveUntil(LoginScreen.loginUrl, (route) => false);
    });
  }

  static Widget buildLoadMoreIndicator() {
    return SizedBox(
      height: 30,
      child: CToast.instance.showLoader(),
    );
  }
}

class NoGlow extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
