import 'package:conduit/bloc/all_articles_bloc/all_airtist_event.dart';
import 'package:conduit/bloc/all_articles_bloc/all_articles_bloc.dart';
import 'package:conduit/bloc/login_bloc/login_bloc.dart';
import 'package:conduit/model/auth_model.dart';
import 'package:conduit/repository/all_airtist_repo.dart';
import 'package:conduit/ui/home/global.dart';
import 'package:conduit/ui/home/yourfeed.dart';
import 'package:conduit/ui/login/login_screen.dart';
import 'package:conduit/ui/profile/profile_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AllArticlesBloc ArticlesBloc;
  bool isLoading = false;

  @override
  void initState() {
    ArticlesBloc = context.read<AllArticlesBloc>();
    ArticlesBloc.add(allArticlesEvent());
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final pages = [const YourFeedScreen(), const GlobalScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: Container(),
        centerTitle: true,
        title: Column(
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: AppColors.primaryColor,
        // fixedColor: AppColors.white,
        currentIndex: _selectedIndex,
        unselectedItemColor: AppColors.text_color,
        selectedItemColor: AppColors.primaryColor2,
        // unselectedItemColor: Colors.grey,

        type: BottomNavigationBarType.shifting,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.feed_outlined),
              label: "Your Feed",
              backgroundColor: AppColors.primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: "Global",
              backgroundColor: AppColors.bottomColor2),
        ],
      ),
      endDrawer: Opacity(
        opacity: 1,
        child: Drawer(
          backgroundColor: AppColors.white2,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.white,
                ),
                child: Center(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()));
                  },
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
                )),
              ),
              ListTile(
                  title: const Text('Global'),
                  leading: Icon(Icons.feed),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              ListTile(
                title: const Text('Your Feed'),
                leading: Icon(Icons.people),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: onLogout,
                  child: IntrinsicWidth(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 40),
                      child: Row(
                        children: [
                          Text(
                            "Sign Out",
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
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
                      // Expanded(
                      //   child: TextButton(
                      //     style: ButtonStyle(
                      //       minimumSize: MaterialStateProperty.all<Size>(
                      //           Size(MediaQuery.of(context).size.width, 40)),
                      //       shape: MaterialStateProperty.all<
                      //           RoundedRectangleBorder>(RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(12.0),
                      //       )),
                      //       backgroundColor: MaterialStateProperty.all<Color>(
                      //           AppColors.pholder_background),
                      //     ),
                      //     child: new Text('Cancel',
                      //         // textAlign: TextAlign.center,
                      //         style:
                      //             Theme.of(context).textTheme.button?.copyWith(
                      //                   fontFamily: KSMFontFamily.robotoRgular,
                      //                   color: Colors.white,
                      //                 )),
                      //     onPressed: () {
                      //       Navigator.pop(context, false);
                      //     },
                      //   ),
                      // ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: FlatButton(
                          height: 40,
                          color: AppColors.primaryColor,
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
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                        ),
                      ),
                      // Expanded(
                      //   child: TextButton(
                      //     style: ButtonStyle(
                      //       minimumSize: MaterialStateProperty.all<Size>(
                      //           Size(MediaQuery.of(context).size.width, 40)),
                      //       shape: MaterialStateProperty.all<
                      //           RoundedRectangleBorder>(RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(12.0),
                      //       )),
                      //       backgroundColor: MaterialStateProperty.all<Color>(
                      //           AppColors.button_color),
                      //     ),
                      //     child: new Text('Confirm',
                      //         // textAlign: TextAlign.center,
                      //         style:
                      //             Theme.of(context).textTheme.button?.copyWith(
                      //                   fontFamily: KSMFontFamily.robotoRgular,
                      //                   color: Colors.white,
                      //                 )),
                      //     onPressed: () {
                      //       Navigator.pop(context, true);
                      //     },
                      //   ),
                      // ),
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
