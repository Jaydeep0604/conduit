import 'package:conduit/bloc/all_articles_bloc/all_articles_bloc.dart';
import 'package:conduit/config/hive_store.dart';
import 'package:conduit/ui/home/add_article_screen.dart';
import 'package:conduit/ui/home/global.dart';
import 'package:conduit/ui/home/yourfeed.dart';
import 'package:conduit/ui/login/login_screen.dart';
import 'package:conduit/ui/profile/profile_screen.dart';
import 'package:conduit/ui/setting/setting_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AllArticlesBloc ArticlesBloc;
  bool isLoading = false;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final pages = [const GlobalScreen(), YourFeedScreen(), AddArticleScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingScreen(),
                ),
              );
            },
            child: Icon(Icons.settings)),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "conduit",
              style: TextStyle(color: AppColors.primaryColor2, fontSize: 30),
            ),
            Text(
              "A place to share your knowledge.",
              style: TextStyle(color: AppColors.white, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
              child: Icon(Icons.person),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primaryColor,
        // fixedColor: AppColors.white,
        currentIndex: _selectedIndex,
        unselectedItemColor: AppColors.white2,
        selectedItemColor: AppColors.white,

        // unselectedItemColor: Colors.grey,

        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.feed_outlined,
                color: AppColors.white,
              ),
              label: "Globle",
              backgroundColor: AppColors.primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: AppColors.white,
              ),
              label: "Your Feed",
              backgroundColor: AppColors.primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                color: AppColors.white,
              ),
              label: "Add",
              backgroundColor: AppColors.primaryColor),
        ],
      ),
      // drawer: Opacity(
      //   opacity: 1,
      //   child: Drawer(
      //     backgroundColor: AppColors.white2,
      //     child: ListView(
      //       children: [
      //         DrawerHeader(
      //           decoration: BoxDecoration(
      //             color: AppColors.white,
      //           ),
      //           child: Center(
      //               child: GestureDetector(
      //             onTap: () {
      //               Navigator.pop(context);
      //               Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       builder: (context) => ProfileScreen()));
      //             },
      //             child: Container(
      //               decoration: BoxDecoration(
      //                 border: Border.all(color: AppColors.primaryColor),
      //                 borderRadius: BorderRadius.circular(50),
      //               ),
      //               child: CircleAvatar(
      //                 backgroundColor: AppColors.white2,
      //                 child: Icon(
      //                   Icons.person,
      //                   color: AppColors.primaryColor,
      //                   size: 65,
      //                 ),
      //                 radius: 45,
      //               ),
      //             ),
      //           )),
      //         ),
      //         ListTile(
      //             title: const Text('Global'),
      //             leading: Icon(Icons.feed),
      //             onTap: () {
      //               Navigator.pop(context);
      //             }),
      //         ListTile(
      //           title: const Text('Your Feed'),
      //           leading: Icon(Icons.people),
      //           onTap: () {
      //             Navigator.pop(context);
      //           },
      //         ),
      //         Align(
      //           alignment: Alignment.bottomRight,
      //           child: InkWell(
      //             onTap: onLogout,
      //             child: IntrinsicWidth(
      //               child: Padding(
      //                 padding: const EdgeInsets.only(
      //                     left: 10.0, right: 10.0, bottom: 40),
      //                 child: Row(
      //                   children: [
      //                     Text(
      //                       "Sign Out",
      //                       style: TextStyle(
      //                         fontSize: 14.0,
      //                       ),
      //                     ),
      //                     SizedBox(width: 5),
      //                     Icon(
      //                       Icons.arrow_forward_ios_rounded,
      //                       size: 16,
      //                     )
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      body: pages[_selectedIndex],
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
                          color: Color.fromARGB(255, 197, 197, 197),
                          // fontFamily: KSMFontFamily.robotoThin,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                            height: 40,
                            color: AppColors.pholder_background,
                            disabledColor: AppColors.pholder_background,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            child: new Text('Cancel',
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    ?.copyWith(
                                        // fontFamily: KSMFontFamily.robotoRgular
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
                        child: FlatButton(
                          height: 40,
                          color: AppColors.primaryColor,
                          // disabledColor: AppColors.Bottom_bar_color,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: new Text('Confirm',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  ?.copyWith(
                                      //fontFamily: KSMFontFamily.robotoRgular
                                      )
                                  .copyWith(color: Colors.white)),
                          onPressed: () async {
                            await hiveStore.logOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              (route) => false,
                            );
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
