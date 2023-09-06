import 'package:conduit/main.dart';
import 'package:conduit/ui/home/home_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/widget/theme_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YourFeedScreen extends StatefulWidget {
  const YourFeedScreen({Key? key}) : super(key: key);

  @override
  State<YourFeedScreen> createState() => _YourFeedScreenState();
}

class _YourFeedScreenState extends State<YourFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: false,
        leading: InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
            child: Icon(Icons.arrow_back)),
        title: Text(
          "Feed",
          style: TextStyle(
            color: AppColors.white,
            fontFamily: ConduitFontFamily.robotoRegular,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async => true,
        child: ThemeContainer(
          child: SafeArea(
            child: Center(
              child: Text(
                "No articles are hear... yet.",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 16,
                  fontFamily: ConduitFontFamily.robotoRegular,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
