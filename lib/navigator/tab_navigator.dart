import 'package:conduit/navigator/route.dart';
import 'package:conduit/navigator/tab_items.dart';
import 'package:conduit/utils/route_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorRoute {
  static const String root = '/';
}

class TabNavigator extends StatefulWidget {
  TabNavigator({Key? key, required this.navigatorKey, required this.tabItem})
      : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey;
  final MyTabItem tabItem;

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        return ScaleRouteWithBuilder(
          builder: (context, a1, a2) => CRoutes.generateRoute(
              context, widget.tabItem.index,
              settings: settings)[settings.name]!(context),
          settings: settings,
        );
      },
    );    
  }
}
