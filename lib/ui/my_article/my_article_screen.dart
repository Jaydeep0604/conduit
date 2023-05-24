import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';

class MyArticlescreen extends StatefulWidget {
  const MyArticlescreen({Key? key}) : super(key: key);

  @override
  State<MyArticlescreen> createState() => _MyArticlescreenState();
}

class _MyArticlescreenState extends State<MyArticlescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(color: AppColors.Bottom_bar_color, height: 700),
          ),
        ),
      ),
    );
  }
}
