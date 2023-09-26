import 'package:conduit/main.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CToast {
  static final CToast instance = CToast._internal();

  factory CToast(BuildContext context) {
    return instance;
  }

  CToast._internal();

  // simple toast

  showToastSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.button_color,
      textColor: Colors.white,
      fontSize: 12.0,
    );
  }

  showToastError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red[400],
      textColor: Colors.white,
      fontSize: 12.0,
    );
  }

  // Scaffold message

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
          fontFamily: ConduitFontFamily.robotoMedium,
          fontSize: 12,
        ),
      ),
      backgroundColor: Colors.red[400],
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      // duration: Duration(seconds: 2),
      duration: Duration(milliseconds: 1800),
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
            fontFamily: ConduitFontFamily.robotoMedium),
      ),
      // backgroundColor: AppColors.black,
      behavior: SnackBarBehavior.floating,
      // duration: Duration(seconds: 2),
      duration: Duration(milliseconds: 1800),
      elevation: 10,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    ));
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
          fontFamily: ConduitFontFamily.robotoMedium,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
      elevation: 10,
      backgroundColor: AppColors.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    ));
  }

  // loaders

  showLoader() {
    return Center(
        child: LoadingAnimationWidget.threeArchedCircle(
      color: Colors.black,
      size: 40,
      // MyApp.themeNotifier.value == ThemeMode.dark
      //     ? Colors.white
      //     : Colors.black,
    ));
  }

  showLoaderWhite() {
    return Center(
        child: LoadingAnimationWidget.threeArchedCircle(
      color: AppColors.white,
      size: 40,
    ));
  }

  void showLodingLoader(BuildContext context) {
    SmartDialog.showLoading();
  }

  showLoading(BuildContext context) {
    SmartDialog.showLoading(
      animationType: SmartAnimationType.fade,
      backDismiss: true,
      useAnimation: true,
      usePenetrate: true,
      msg: "Loading",
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CToast.instance.showLoaderWhite(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Loading...",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontFamily: ConduitFontFamily.robotoMedium,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // dismiss loader first for SmartDialog and second for showLoaderDialog

  void dismiss() {
    SmartDialog.dismiss();
  }

  // void dismiss2(context) {
  //   Navigator.pop(context);
  // }
}
