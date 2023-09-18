import 'package:conduit/main.dart';
import 'package:conduit/ui/change_password/change_password_screen.dart';
import 'package:conduit/ui/profile/profile_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/functions.dart';
import 'package:conduit/utils/image_string.dart';
import 'package:conduit/utils/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ConduitDrawer extends StatelessWidget {
  const ConduitDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1,
      child: Drawer(
        backgroundColor: AppColors.white2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
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
                    child: SvgPicture.asset(
                      ic_profile_icon,
                      color: AppColors.primaryColor,
                      height: 65,
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
              leading: SvgPicture.asset(
                ic_profile_icon,
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
              leading: SvgPicture.asset(
                ic_reset_password_icon,
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
                onLogout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  onLogout(BuildContext context) {
    showAlertBottomSheet(context).then((value) {
      if (value != null) {
        if (value == true) {
          //  settingBloc.add(LogoutEvent());
        }
      }
    });
  }

  Future showAlertBottomSheet(BuildContext context) {
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
