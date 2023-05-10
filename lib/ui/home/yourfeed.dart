import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';

class YourFeedScreen extends StatefulWidget {
  const YourFeedScreen({ Key? key }) : super(key: key);

  @override
  State<YourFeedScreen> createState() => _YourFeedScreenState();
}

class _YourFeedScreenState extends State<YourFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Not Developed",style: TextStyle(color: AppColors.primaryColor,fontSize: 18),),
    );
  }
}