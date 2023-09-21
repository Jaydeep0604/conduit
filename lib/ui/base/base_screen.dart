import 'package:conduit/navigator/tab_items.dart';
import 'package:conduit/navigator/tab_navigator.dart';
import 'package:conduit/ui/base/drawer.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  static const baseUrl = '/base';
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();

  static openDrawer(BuildContext context) {
    _BaseScreenState? state =
        context.findAncestorStateOfType<_BaseScreenState>();
    state?.openDrawer();
  }

  static getCurrentTab(BuildContext context) {
    _BaseScreenState? state =
        context.findAncestorStateOfType<_BaseScreenState>();
    return state?._currentTab;
  }

  static switchTab(BuildContext context, MyTabItem myTabItem) {
    _BaseScreenState? state =
        context.findAncestorStateOfType<_BaseScreenState>();
    state?.selectTab(myTabItem);
  }
}

class _BaseScreenState extends State<BaseScreen> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  var _currentTab = MyTabItem.globalfeed;

  openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  // void didChangeDependancies(){
  //   userdat
  // }

  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await navigatorKey[_currentTab]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentTab != MyTabItem.globalfeed) {
            selectTab(MyTabItem.globalfeed);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          enableFeedback: true,
          backgroundColor: AppColors.white,
          currentIndex: tabIndex[_currentTab] ?? 0,
          // unselectedItemColor: AppColors.black.withOpacity(0.7),
          unselectedIconTheme: IconThemeData(
            color: AppColors.black.withOpacity(0.7),
          ),
          selectedItemColor: AppColors.primaryColor,
          onTap: (index) {
            selectTab(MyTabItem.values[index]);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.globe,
                color: AppColors.black.withOpacity(0.7),
              ),
              activeIcon: Icon(
                CupertinoIcons.globe,
                color: AppColors.primaryColor,
              ),
              label: "Global Feed",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.doc_text,
                color: AppColors.black.withOpacity(0.7),
              ),
              activeIcon: Icon(
                CupertinoIcons.doc_text,
                color: AppColors.primaryColor,
              ),
              label: "Your Feed",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.add,
                color: AppColors.black.withOpacity(0.7),
              ),
              activeIcon: Icon(
                CupertinoIcons.add,
                color: AppColors.primaryColor,
              ),
              label: "Add Article",
            ),
          ],
        ),
        // BottomNavigation(
        //   currentTab: _currentTab,
        //   onSelectTab: _selectTab,
        // ),
        drawer: ConduitDrawer(),
        body: Stack(
          children: [
            Container(
              child: MyTabItem.globalfeed == _currentTab
                  ? _buildOffstageNavigator(MyTabItem.globalfeed)
                  : MyTabItem.yourfeed == _currentTab
                      ? _buildOffstageNavigator(MyTabItem.yourfeed)
                      : _buildOffstageNavigator(MyTabItem.addarticle),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(MyTabItem tabItem) {
    bool isOffset = _currentTab != tabItem;
    return Offstage(
      offstage: isOffset,
      child: TabNavigator(
        navigatorKey: navigatorKey[tabItem]!,
        tabItem: tabItem,
      ),
    );
  }

  void selectTab(MyTabItem tabItem) {
    if (tabItem == _currentTab) {
      if (tabItem == MyTabItem.globalfeed) {
        setState(() {});
      }
      navigatorKey[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  Map<MyTabItem, int> tabIndex = {
    MyTabItem.globalfeed: 0,
    MyTabItem.yourfeed: 1,
    MyTabItem.addarticle: 2,
  };
}
