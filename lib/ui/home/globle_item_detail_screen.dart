import 'dart:async';
import 'package:conduit/bloc/add_comment_bloc/add_comment_bloc.dart';
import 'package:conduit/bloc/add_comment_bloc/add_comment_event.dart';
import 'package:conduit/bloc/add_comment_bloc/add_comment_state.dart';
import 'package:conduit/bloc/all_articles_bloc/all_articles_event.dart';
import 'package:conduit/config/shared_preferences_store.dart';
import 'package:conduit/model/all_artist_model.dart';
import 'package:conduit/model/comment_model.dart';
import 'package:conduit/ui/home/comment_screen.dart';
import 'package:conduit/ui/home/user_profile_detail_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalItemDetailScreen extends StatefulWidget {
  GlobalItemDetailScreen({
    Key? key,
    this.allArticlesModel,
  }) : super(key: key);
  AllArticlesModel? allArticlesModel;

  @override
  State<GlobalItemDetailScreen> createState() => _GlobalItemDetailScreenState();
}

class _GlobalItemDetailScreenState extends State<GlobalItemDetailScreen> {
  Timer? timer;
  bool comment = false;
  bool isLoading = false;

  GlobalKey<FormState> _form = GlobalKey<FormState>();
  void initState() {
    super.initState();

    timer = Timer(Duration(seconds: 2), () {
      setState(() {
        comment = true;
      });
    });

    store();
  }

  store() async {
    sharedPreferencesStore.storeSlug(
      await widget.allArticlesModel!.slug!,
    );
  }

  @override
  Widget build(BuildContext context) {
    // List<String> lines = widget.allArticlesModel.body!.split('\n');
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.white2,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          // centerTitle: true,
          title: Text(
            "Details",
            style: TextStyle(color: AppColors.white, fontSize: 20),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  // boxShadow: [
                  //   BoxShadow(
                  //       color: AppColors.white.withOpacity(0.4), blurRadius: 8)
                  // ],
                ),
                child: Transform.scale(
                  scale: 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: widget.allArticlesModel!.favorited
                        ? Icon(
                            Icons.favorite_border,
                            // size: 60,
                            color: AppColors.primaryColor,
                          )
                        : Icon(
                            Icons.favorite,
                            color: AppColors.primaryColor,
                            // size: 60,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              if (comment == false)
                Expanded(
                  child: CToast.instance.showLoader(),
                ),
              if (comment == true)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: AppColors.black.withOpacity(0.8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${widget.allArticlesModel?.title}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UserProfileDetailScreen(
                                                  allArticlesModel:
                                                      widget.allArticlesModel!,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: CircleAvatar(
                                                  radius: 15,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Image.network(
                                                        "${widget.allArticlesModel?.author!.image}"),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                ),
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            "${widget.allArticlesModel?.author!.username.toString()}",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: AppColors
                                                                    .primaryColor),
                                                          )),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: Text(
                                                          "${widget.allArticlesModel?.createdAt.toString().trimLeft()}",
                                                          style: TextStyle(
                                                              fontSize: 9,
                                                              color: AppColors
                                                                  .white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: AppColors.white2)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 7),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  size: 16,
                                                  color: AppColors.white2,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Follow",
                                                  style: TextStyle(
                                                      color: AppColors.white2,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color:
                                                      AppColors.primaryColor)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 7),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.favorite,
                                                  size: 16,
                                                  color: AppColors.primaryColor,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "( ${widget.allArticlesModel?.favoritesCount} )",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 10, bottom: 10),
                              child: Text(
                                "${widget.allArticlesModel?.body}",
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                            // ListView.separated(
                            //   padding: EdgeInsets.zero,
                            //   primary: false,
                            //   shrinkWrap: true,
                            //   itemCount: lines.length,
                            //   itemBuilder: (BuildContext context, int index) {
                            //     return Text(
                            //       lines[index],
                            //       textAlign: TextAlign.left,
                            //       style: TextStyle(fontSize: 14.0),
                            //     );
                            //   },
                            //   separatorBuilder: (context, index) {
                            //     return SizedBox();
                            //   },
                            // )
                            if (widget.allArticlesModel!.tagList!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 10, bottom: 10),
                                child: SizedBox(
                                  height: 30,
                                  child: ListView.separated(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    primary: false,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget
                                        .allArticlesModel!.tagList!.length,
                                    itemBuilder:
                                        (BuildContext ctxt, int index) {
                                      return Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: AppColors.white),
                                          child: Center(
                                              child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            child: Text(
                                              " ${widget.allArticlesModel!.tagList![index]} ",
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          )));
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        width: 5,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, bottom: 5),
                              child: Divider(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UserProfileDetailScreen(
                                                      allArticlesModel: widget
                                                          .allArticlesModel!)));
                                    },
                                    child: Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: CircleAvatar(
                                            radius: 15,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                  "${widget.allArticlesModel?.author!.image}"),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      "${widget.allArticlesModel?.author!.username.toString()}",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: AppColors
                                                              .primaryColor),
                                                    )),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Text(
                                                    "${widget.allArticlesModel?.createdAt.toString().trimLeft()}",
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        color: AppColors
                                                            .text_color),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(width: 10,),
                                  Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: AppColors.text_color)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 7),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.add,
                                            size: 16,
                                            color: AppColors.text_color,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Follow",
                                            style: TextStyle(
                                                color: AppColors.text_color,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: AppColors.primaryColor)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 7),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            size: 16,
                                            color: AppColors.primaryColor,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "( ${widget.allArticlesModel?.favoritesCount} )",
                                            style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AddCommentScreen(
                                allArticlesModel: widget.allArticlesModel),
                            SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              child: comment
                                  ? CommentViewScreen()
                                  : CToast.instance.showLoader(),
                              // : SizedBox(),
                            ),
                            SizedBox(height: 10.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
