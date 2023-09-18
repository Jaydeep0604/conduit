import 'package:conduit/services/user_service.dart';
import 'package:conduit/ui/add_article/add_article_screen.dart';
import 'package:conduit/ui/global/global.dart';
import 'package:conduit/ui/feed/yourfeed.dart';
import 'package:conduit/ui/base/drawer.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();

  static openDrawer(BuildContext context) {
    _BaseScreenState? state =
        context.findAncestorStateOfType<_BaseScreenState>();
    state?.openDrawer();
  }
}

class _BaseScreenState extends State<BaseScreen> {
  // late AllArticlesBloc ArticlesBloc;
  late UserStateContainerState userState;
  // late GlobalKey<ScaffoldState> globalScaffoldKey;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void initState() {
    super.initState();
  }

  final pages = [
    const GlobalScreen(),
    const YourFeedScreen(),
    AddArticleScreen(
      isUpdateArticle: false,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        key: _scaffoldKey,
        // backgroundColor: AppColors.white2,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.white,
          // fixedColor: AppColors.white,
          currentIndex: _selectedIndex,
          unselectedItemColor: AppColors.black.withOpacity(0.7),
          selectedItemColor: AppColors.primaryColor,

          // unselectedItemColor: Colors.grey,

          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.feed_outlined,
                  color: _selectedIndex == 0
                      ? AppColors.primaryColor
                      : AppColors.black.withOpacity(0.7),
                ),
                label: "Global",
                backgroundColor: AppColors.primaryColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: _selectedIndex == 1
                      ? AppColors.primaryColor
                      : AppColors.black.withOpacity(0.7),
                ),
                label: "Your Feed",
                backgroundColor: AppColors.primaryColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  color: _selectedIndex == 2
                      ? AppColors.primaryColor
                      : AppColors.black.withOpacity(0.7),
                ),
                label: "Add",
                backgroundColor: AppColors.primaryColor),
          ],
        ),
        drawer: ConduitDrawer(),
        body: pages[_selectedIndex],
      ),
    );
  }
}
