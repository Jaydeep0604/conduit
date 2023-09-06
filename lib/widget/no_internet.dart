import 'package:conduit/main.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/cupertino.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    ));
  }
}
