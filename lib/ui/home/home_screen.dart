import 'package:conduit/bloc/all_articles_bloc/all_articles_bloc.dart';
import 'package:conduit/bloc/all_articles_bloc/all_articles_event.dart';
import 'package:conduit/main.dart';
import 'package:conduit/services/user_service.dart';
import 'package:conduit/ui/change_password/change_password_screen.dart';
import 'package:conduit/ui/home/add_article_screen.dart';
import 'package:conduit/ui/home/global.dart';
import 'package:conduit/ui/home/yourfeed.dart';
import 'package:conduit/ui/profile/profile_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/functions.dart';
import 'package:conduit/utils/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static openDrawer(BuildContext context) {
    _HomeScreenState? state =
        context.findAncestorStateOfType<_HomeScreenState>();
    state?.openDrawer();
  }
}

class _HomeScreenState extends State<HomeScreen> {
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

  // logOut() {
  //   hiveStore.logOut();
  //   UserStateContainer.of(context).updateUser(userResponseModel: null);
  //   UserStateContainer.of(context).updateLoggedStatus(false);
  //   Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => LoginScreen(),
  //       ));
  // }

  // @override
  // void didChangeDependencies() {
  //   userState = UserStateContainer.of(context);
  //   if (userState.user == null && userState.isLoggedIn == true) {
  //     // AvmToast.instance.showLoading(context);
  //     if (mounted) {
  //       userState.initUser().whenComplete(() {
  //         // AvmToast.instance.dismiss();
  //       });
  //     }
  //   }
  //   super.didChangeDependencies();
  // }

  final pages = [const GlobalScreen(), YourFeedScreen(), AddArticleScreen()];

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
                label: "Globle",
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
        drawer: Opacity(
          opacity: 1,
          child: Drawer(
            backgroundColor: AppColors.white2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                  ),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: CircleAvatar(
                        backgroundColor: AppColors.white2,
                        child: Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                          size: 65,
                        ),
                        radius: 45,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Profile',
                    style: TextStyle(
                      fontFamily: ConduitFontFamily.robotoRegular,
                    ),
                  ),
                  leading: Icon(
                    CupertinoIcons.person,
                    color: AppColors.primaryColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                ),
                Divider(endIndent: 20, indent: 20),
                ListTile(
                  title: const Text(
                    'Change Password',
                    style: TextStyle(
                      fontFamily: ConduitFontFamily.robotoRegular,
                    ),
                  ),
                  leading: Icon(
                    Icons.password,
                    color: AppColors.primaryColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ChangePassword(),
                      ),
                    );
                  },
                ),
                Divider(endIndent: 20, indent: 20),
                ListTile(
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: ConduitFontFamily.robotoRegular,
                    ),
                  ),
                  leading: Icon(
                    Icons.logout_outlined,
                    color: AppColors.primaryColor,
                  ),
                  onTap: () {
                    onLogout();
                  },
                ),
              ],
            ),
          ),
        ),
        body: pages[_selectedIndex],
      ),
    );
  }

  onLogout() {
    showAlertBottomSheet().then((value) {
      if (value != null) {
        if (value == true) {
          //  settingBloc.add(LogoutEvent());
        }
      }
    });
  }

  Future showAlertBottomSheet() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Color.fromARGB(255, 19, 19, 19),
      builder: (context) {
        return IntrinsicHeight(
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Text(
                    "Are you sure you want to sign out ?",
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: AppColors.white,
                          fontFamily: ConduitFontFamily.robotoThin,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                            height: 40,
                            color: AppColors.pholder_background,
                            disabledColor: AppColors.pholder_background,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: new Text('Cancel',
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    ?.copyWith(
                                      fontFamily:
                                          ConduitFontFamily.robotoRegular,
                                    )
                                    .copyWith(color: Colors.white)),
                            onPressed: () {
                              Navigator.pop(context, false);
                            }),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: MaterialButton(
                          height: 40,
                          color: AppColors.primaryColor,
                          disabledColor: AppColors.Bottom_bar_color,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: new Text('Confirm',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  ?.copyWith(
                                    fontFamily: ConduitFontFamily.robotoRegular,
                                  )
                                  .copyWith(color: Colors.white)),
                          onPressed: () async {
                            Navigator.pop(context);
                            CToast.instance.showLoaderDialog(context);
                            ConduitFunctions.logOut(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
