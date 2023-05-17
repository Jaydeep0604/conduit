import 'package:conduit/main.dart';
import 'package:conduit/model/all_artist_model.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';

class UserProfileDetailScreen extends StatefulWidget {
  UserProfileDetailScreen({Key? key, required this.allArticlesModel})
      : super(key: key);
  AllArticlesModel allArticlesModel;

  @override
  State<UserProfileDetailScreen> createState() =>
      _UserProfileDetailScreenState();
}

class _UserProfileDetailScreenState extends State<UserProfileDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        // centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(color: AppColors.white, fontSize: 20),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.black.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.black),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              "${widget.allArticlesModel.author!.image}",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Text(
                          '${widget.allArticlesModel.author!.username}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor),
                          borderRadius: BorderRadius.circular(10),
                          color: widget.allArticlesModel.author!.following
                              ? AppColors.primaryColor
                              : AppColors.white),
                      child: Center(
                        child: Text(
                          widget.allArticlesModel.author!.following
                              ? "Following"
                              : "Follow",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: widget.allArticlesModel.author!.following
                                  ? AppColors.white
                                  : AppColors.primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
