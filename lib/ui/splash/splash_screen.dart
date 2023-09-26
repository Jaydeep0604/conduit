import 'dart:async';
import 'package:conduit/config/hive_store.dart';
import 'package:conduit/main.dart';
import 'package:conduit/model/user_model.dart';
import 'package:conduit/ui/base/base_screen.dart';
import 'package:conduit/ui/login/login_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  static const splashUrl = "/splash";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isShow = false;

  @override
  void didChangeDependencies() {
    Timer(Duration(milliseconds: 800), () {
      setState(() {
        isShow = true;
      });
    });
    Timer(Duration(milliseconds: 4300), () async {
      Box<UserAccessData>? detailModel =
          await hiveStore.isExistUserAccessData();
      if (detailModel!.values.isNotEmpty) {
        Navigator.pushNamedAndRemoveUntil(
            context, BaseScreen.baseUrl, (route) => false);
      }
      if (detailModel.values.isEmpty)
        Navigator.pushReplacementNamed(context, LoginScreen.loginUrl);
    });

    super.didChangeDependencies();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   Timer(Duration(milliseconds: 1800), () async {
  //     Box<UserAccessData>? detailModel =
  //         await hiveStore.isExistUserAccessData();
  //     if (detailModel!.values.isNotEmpty) {
  //       Navigator.pushNamedAndRemoveUntil(
  //           context, BaseScreen.baseUrl, (route) => false);
  //     }
  //     if (detailModel.values.isEmpty)
  //       Navigator.pushReplacementNamed(context, LoginScreen.loginUrl);
  //   });
  //   // Timer(
  //   //     Duration(seconds: 1),
  //   //     () => Navigator.pushReplacement(
  //   //         context, MaterialPageRoute(builder: (context) => LoginScreen())));
  // }

  List<Color> colorizeColors = [
    Color.fromARGB(255, 5, 156, 5), // Dark Green
    Color.fromARGB(255, 0, 100, 100), // Dark Teal
    Color.fromARGB(255, 0, 128, 81), // Dark Green (similar to the first color)
    Color.fromARGB(255, 28, 127, 106),
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 40.0,
    fontFamily: ConduitFontFamily.robotoBold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 128, 222, 173),
              Color.fromARGB(255, 209, 225, 216),
              Color.fromARGB(255, 209, 225, 216),
              Color.fromARGB(255, 115, 221, 166),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text(
              //   'conduit',
              //   style: TextStyle(
              //     fontSize: 40,
              //     color: AppColors.primaryColor,
              //     fontFamily: ConduitFontFamily.robotoRegular,
              //   ),
              // ),
              LoadingAnimationWidget.halfTriangleDot(
                color: AppColors.advertisement_color,
                size: 40,
              ),
              SizedBox(
                height: 5,
              ),
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'conduit',
                    textAlign: TextAlign.center,
                    speed: Duration(
                      milliseconds: 400,
                    ),
                    textStyle: colorizeTextStyle,
                    colors: colorizeColors,
                  ),
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
              ),
              SizedBox(
                height: 5,
              ),
              isShow?
                SizedBox(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontFamily: ConduitFontFamily.robotoRegular,
                    ),
                    child: AnimatedTextKit(
                        isRepeatingAnimation: true,
                        totalRepeatCount: 1,
                        animatedTexts: [
                          TyperAnimatedText(
                            'A place to share your knowledge.',
                            speed: Duration(
                              milliseconds: 80,
                            ),
                            textAlign: TextAlign.center,
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: AppColors.primaryColor2,
                              fontFamily: ConduitFontFamily.robotoRegular,
                            ),
                          ),
                        ]),
                  ),
                ):SizedBox(height: 20,),
              // Text(
              //   'A place to share your knowledge.',
              //   style: TextStyle(
              //     fontSize: 18,
              //     color: AppColors.primaryColor2,
              //     fontFamily: ConduitFontFamily.robotoRegular,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
