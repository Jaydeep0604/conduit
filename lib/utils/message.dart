// import 'package:flash/flash.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../main.dart';

class CToast {
  static final CToast instance = CToast._internal();

  factory CToast(BuildContext context) {
    return instance;
  }

  CToast._internal();
  showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    // showToastError(msg);
    // showTopFlash( context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      // behavior: SnackBarBehavior.fixed,
      content: Text(
        "$msg",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          //fontFamily: KSMFontFamily.robotomedium,
          fontSize: 12,
        ),
      ),
      backgroundColor: Colors.red[400],
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      // behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
      dismissDirection: DismissDirection.horizontal,

      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    ));
  }

  showSuccess(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "$msg",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 12,
            // fontFamily: KSMFontFamily.robotomedium
            ),
      ),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
      elevation: 10,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    ));
  }

  showLoader() {
    return Center(
        child: LoadingAnimationWidget.threeArchedCircle(
      color: MyApp.themeNotifier.value == ThemeMode.dark
          ? Colors.white
          : Colors.black,
      size: 40,
    ));
  }

  void showLoading(BuildContext context) {
    SmartDialog.showLoading(
        animationType: SmartAnimationType.fade,
        backDismiss: true,
        useAnimation: true,
        usePenetrate: true,
        msg: "Loading");
  }

  void dismiss() {
    SmartDialog.dismiss();
  }

  showToastSuccess(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.button_color,
        textColor: Colors.white,
        fontSize: 12.0);
  }

  showToastError(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red[400],
        textColor: Colors.white,
        fontSize: 12.0);
  }
  showToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "$msg",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: AppColors.black,
            fontSize: 12,
            // fontFamily: KSMFontFamily.robotomedium
            ),
      ),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
      elevation: 10,
      backgroundColor: AppColors.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    ));
  }


}
