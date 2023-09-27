import 'package:conduit/main.dart';
import 'package:conduit/navigator/tab_items.dart';
import 'package:conduit/ui/base/base_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/image_string.dart';
import 'package:conduit/utils/theme_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AboutUsScreen extends StatelessWidget {
  static const aboutUsUrl = "/aboutusurl";
  AboutUsScreen({Key? key}) : super(key: key);

  String about =
      "Conduit provides a space for writers to share their content, readers to engage with thought-provoking articles, and a sense of community through user interactions and discussions. \n\nWhether you're an author looking to publish your work or a reader seeking insightful content, Conduit offers a dynamic and engaging platform.";
  String about_second =
      "Conduit offers an inclusive platform where writers can freely share their content, while readers delve into a world of thought-provoking articles.\n\n It's a vibrant hub for meaningful interactions and discussions, fostering a sense of belonging within its community.\n\n Whether you're an aspiring author seeking to showcase your work or a curious reader on the lookout for insightful content, Conduit provides an engaging and dynamic environment to meet your needs.\n\n Explore diverse perspectives, express your thoughts, and connect with others who share your passion for storytelling.\n\n Join Conduit today and be part of this enriching content-sharing experience.";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: false,
        leading: Container(
          child: IconButton(
            onPressed: ()  {
             Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              ic_back_arrow_icon,
              color: AppColors.white,
            ),
          ),
        ),
        title: Text(
          "About Us",
          style: TextStyle(
            color: AppColors.white,
            fontFamily: ConduitFontFamily.robotoRegular,
          ),
        ),
      ),
      body: SafeArea(
          child: ThemeContainer(
            child: Column(
                  children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                 
                  Color.fromARGB(255, 54, 55, 54),
                  Color.fromARGB(255, 67, 78, 68),
                ],
              ),
                ),
                child: RichText(
                  text: TextSpan(
                      text: about,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        wordSpacing: 1,
                        fontFamily: ConduitFontFamily.robotoLight
                      )),
                  softWrap: true,
                ),
              ),
            )
                  ],
                ),
          )),
    );
  }
}
