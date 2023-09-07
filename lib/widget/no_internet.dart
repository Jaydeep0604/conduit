import 'package:conduit/main.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/cupertino.dart';

class NoInternet extends StatelessWidget {
  NoInternet({Key? key, this.isWidget = false}) : super(key: key);
  bool isWidget;

  @override
  Widget build(BuildContext context) {
    if (isWidget) {
      return Center(
        child: Text(
          "No internet",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 16,
            fontFamily: ConduitFontFamily.robotoMedium,
          ),
        ),
      );
    }
    return SafeArea(
      child: Center(
        child: Text(
          "No internet",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 16,
            fontFamily: ConduitFontFamily.robotoMedium,
          ),
        ),
      ),
    );
  }
}
