import 'package:conduit/main.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  NoInternet({Key? key, this.isWidget = false, this.onClickRetry})
      : super(key: key);
  bool isWidget;
  void Function()? onClickRetry;

  @override
  Widget build(BuildContext context) {
    if (isWidget) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.transparent,
              child: Image.asset(
                "assets/images/no-conexion.png",
                fit: BoxFit.contain,
                height: 150,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Text(
              "No internet connection",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontFamily: ConduitFontFamily.robotoMedium,
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 30, left: 30),
              alignment: Alignment.bottomCenter,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
              child: MaterialButton(
                height: 40,
                minWidth: MediaQuery.of(context).size.width,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(12.0)),
                child: Text("Retry",
                    style: Theme.of(context).textTheme.button?.copyWith(
                        fontFamily: ConduitFontFamily.robotoBold,
                        color: Colors.black,
                        fontWeight: FontWeight.w700)),
                onPressed: onClickRetry,
              ),
            ),
          ],
        ),
      );
    }
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.transparent,
              child: Image.asset(
                "assets/images/no-conexion.png",
                fit: BoxFit.contain,
                height: 150,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Text(
              "No internet connection",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontFamily: ConduitFontFamily.robotoMedium,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.only(right: 30, left: 30),
              alignment: Alignment.bottomCenter,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
              child: MaterialButton(
                height: 40,
                minWidth: MediaQuery.of(context).size.width,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(12.0)),
                child: Text("Retry",
                    style: Theme.of(context).textTheme.button?.copyWith(
                        fontFamily: ConduitFontFamily.robotoBold,
                        color: Colors.black,
                        fontWeight: FontWeight.w700)),
                onPressed: onClickRetry,
              ),
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
