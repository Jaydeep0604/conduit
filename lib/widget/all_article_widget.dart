import 'package:conduit/bloc/comment_bloc/comment_bloc.dart';
import 'package:conduit/bloc/follow_bloc/follow_bloc.dart';
import 'package:conduit/bloc/follow_bloc/follow_event.dart';
import 'package:conduit/bloc/like_article_bloc/like_article_bloc.dart';
import 'package:conduit/bloc/like_article_bloc/like_article_event.dart';
import 'package:conduit/bloc/tags_bloc/tags_bloc.dart';
import 'package:conduit/main.dart';
import 'package:conduit/model/all_article_model.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:conduit/ui/comments/comments_screen.dart';
import 'package:conduit/ui/home/globle_item_detail_screen.dart';
import 'package:conduit/ui/tag_screen/tag_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/widget/shimmer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AllAirtistWidget extends StatefulWidget {
  AllAirtistWidget({Key? key, this.articlesModel, this.isLoading = false})
      : super(key: key);
  AllArticlesModel? articlesModel;
  bool isLoading;

  factory AllAirtistWidget.shimmer() => AllAirtistWidget(
        isLoading: true,
      );

  @override
  State<AllAirtistWidget> createState() => _AllAirtistWidgetState();
}

class _AllAirtistWidgetState extends State<AllAirtistWidget>
    with SingleTickerProviderStateMixin {
  late LikeBloc likeBloc;
  late FollowBloc followBloc;
  bool? _isLike;
  bool? _isFollow;
  @override
  void initState() {
    super.initState();
    likeBloc = context.read<LikeBloc>();
    _isLike = widget.articlesModel?.favorited;

    followBloc = context.read<FollowBloc>();
    _isFollow = widget.articlesModel?.author?.following;
    ;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // onDoubleTapState() {
  //   setState(() {
  //     _isFollow = true;
  //     if (_isFollow!) {
  //       followBloc.add(
  //           FollowUserEvent(username: widget.articlesModel?.author?.username));
  //     }
  //   });
  // }

  changeFollowState() {
    setState(() {
      _isFollow = !_isFollow!;
      if (_isFollow!) {
        followBloc.add(
            FollowUserEvent(username: widget.articlesModel?.author?.username));
      } else {
        followBloc.add(UnFollowUserEvent(
            username: widget.articlesModel?.author?.username));
      }
    });
  }

  changeLikeState() {
    setState(() {
      _isLike = !_isLike!;
      if (_isLike!) {
        likeBloc.add(LikeArticleEvent(slug: widget.articlesModel!.slug!));
      } else {
        likeBloc.add(RemoveLikeArticleEvent(slug: widget.articlesModel!.slug!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Container(
        height: 110,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.black.withOpacity(0.031)),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
              child: Container(
                  height: 43,
                  width: MediaQuery.of(context).size.width,
                  child: ShimmerWidget()),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
              child: Container(height: 8, child: ShimmerWidget()),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
              child: Container(height: 8, child: ShimmerWidget()),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child:
                      Container(height: 18, width: 100, child: ShimmerWidget()),
                ),
                Container(
                  height: 18,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                    child: ListView.separated(
                      reverse: true,
                      shrinkWrap: true,
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Container(
                            height: 18,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppColors.white2),
                            child: ShimmerWidget());
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: 5,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            )
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => CommentBloc(repo: AllArticlesImpl()),
              child: GlobalItemDetailScreen(
                username: widget.articlesModel!.author!.username,
                isFollowed: widget.articlesModel!.author!.following,
                slug: widget.articlesModel!.slug!,
                favorited: widget.articlesModel!.favorited,
              ),
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // height: 160,
        // width: MediaQuery.of(context).size.width,
        // decoration: BoxDecoration(
        //     border: Border.all(color: AppColors.black.withOpacity(0.051)),
        //     color: AppColors.white,
        //     borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      radius: 15,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                            "${widget.articlesModel?.author?.image}"),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "${widget.articlesModel?.author?.username.toString()}",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: ConduitFontFamily.robotoRegular,
                              ),
                            )),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            DateFormat('dd-MM-yyyy').format(
                              DateTime.parse(
                                widget.articlesModel!.createdAt
                                    .toString()
                                    .trimLeft(),
                              ),
                            ),
                            // "${widget.allArticlesModel?.createdAt.toString().trimLeft()}",
                            style: TextStyle(
                              fontSize: 9,
                              color: AppColors.text_color,
                              fontFamily: ConduitFontFamily.robotoRegular,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: changeFollowState,
                //   child: AnimatedSwitcher(
                //     duration: Duration(milliseconds: 200),
                //     switchInCurve: Curves.easeOut,
                //     switchOutCurve: Curves.easeOut,
                //     transitionBuilder:
                //         (Widget child, Animation<double> animation) {
                //       return ScaleTransition(
                //         scale: animation,
                //         child: child,
                //       );
                //     },
                //     child: Container(
                //         padding: EdgeInsets.symmetric(horizontal: 10),
                //         height: 22,
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(5),
                //             border: Border.all(
                //                 color: AppColors.black.withOpacity(0.5))),
                //         child: Center(
                //             child: _isFollow!
                //                 ? Text(
                //                     "Following",
                //                     style: TextStyle(fontSize: 14),
                //                   )
                //                 : Text("Follow"))),
                //   ),
                // ),
                Spacer(),
                SizedBox(
                  width: 10,
                ),
                // GestureDetector(
                //   onTap: changeLikeState,
                //   child: AnimatedSwitcher(
                //     duration: Duration(milliseconds: 200),
                //     switchInCurve: Curves.easeOut,
                //     switchOutCurve: Curves.easeOut,
                //     transitionBuilder:
                //         (Widget child, Animation<double> animation) {
                //       return ScaleTransition(
                //         scale: animation,
                //         child: child,
                //       );
                //     },
                //     child: _isLike!
                //         ? Icon(
                //             Icons.favorite,
                //             size: 25,
                //             color: AppColors.primaryColor,
                //             key: ValueKey<int>(1),
                //           )
                //         : Icon(
                //             Icons.favorite_outline,
                //             color: AppColors.primaryColor,
                //             size: 25,
                //             key: ValueKey<int>(2),
                //           ),
                //   ),
                // ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                child: Text(
                  "${widget.articlesModel?.title}",
                  maxLines: 2,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontFamily: ConduitFontFamily.robotoMedium,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
              child: Container(
                child: Text(
                  "${widget.articlesModel?.body}",
                  maxLines: 3,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 11,
                    color: AppColors.text_color,
                    fontFamily: ConduitFontFamily.robotoLight,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                // Container(
                //   height: 20,
                //   child: Padding(
                //     padding: const EdgeInsets.only(left: 10),
                //     child: Text(
                //       "Read more...",
                //       style: TextStyle(fontSize: 11, color: AppColors.black),
                //     ),
                //   ),
                // ),
                Expanded(
                  child: Container(
                    height: widget.articlesModel!.tagList!.length > 0 ? 20 : 0,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10,left: 10),
                      child: ListView.separated(
                        reverse: true,
                        shrinkWrap: false,
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.articlesModel!.tagList!.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) {
                                    return BlocProvider(
                                      create: (context) => TagsBloc(
                                          repo:
                                              AllArticlesImpl()), // Create a new instance
                                      child: TagScreen(
                                        title: widget
                                            .articlesModel?.tagList![index],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: AppColors.white2),
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 3),
                                  child: Text(
                                    " ${widget.articlesModel?.tagList![index]} ",
                                    style: TextStyle(fontSize: 11,
                                    fontFamily: ConduitFontFamily.robotoRegular,),
                                  ),
                                ))),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 5,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: changeLikeState,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeOut,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: _isLike!
                        ? Icon(
                            Icons.favorite,
                            size: 25,
                            color: AppColors.primaryColor,
                            key: ValueKey<int>(1),
                          )
                        : Icon(
                            Icons.favorite_outline,
                            color: Colors.grey,
                            size: 25,
                            key: ValueKey<int>(2),
                          ),
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) {
                          return CommentsScreen(
                            slug: widget.articlesModel!.slug!,
                          );
                        },
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.comment,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            // SizedBox(
            //   height: 5,
            // )
          ],
        ),
      ),
    );
  }
}
