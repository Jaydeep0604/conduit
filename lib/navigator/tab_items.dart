import 'package:flutter/cupertino.dart';

enum MyTabItem { globalfeed, yourfeed, addarticle }

const Map<MyTabItem, String> tabName = {
  MyTabItem.globalfeed: "global",
  MyTabItem.yourfeed: "your",
  MyTabItem.addarticle: "add"
};

final navigatorKey = {
  MyTabItem.globalfeed: GlobalKey<NavigatorState>(),
  MyTabItem.yourfeed: GlobalKey<NavigatorState>(),
  MyTabItem.addarticle: GlobalKey<NavigatorState>(),
};

final globalNavigationKey = GlobalKey<NavigatorState>();
// final GlobalKey<NavigatorState> globalNavigationKey = GlobalKey<NavigatorState>();
