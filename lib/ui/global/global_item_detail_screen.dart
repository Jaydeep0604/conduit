import 'dart:async';
import 'package:conduit/bloc/article_bloc/article_bloc.dart';
import 'package:conduit/bloc/article_bloc/article_event.dart';
import 'package:conduit/bloc/article_bloc/article_state.dart';
import 'package:conduit/bloc/follow_bloc/follow_bloc.dart';
import 'package:conduit/bloc/follow_bloc/follow_event.dart';
import 'package:conduit/bloc/like_article_bloc/like_article_bloc.dart';
import 'package:conduit/bloc/like_article_bloc/like_article_event.dart';
import 'package:conduit/config/constant.dart';
import 'package:conduit/config/hive_store.dart';
import 'package:conduit/main.dart';
import 'package:conduit/model/user_model.dart';
import 'package:conduit/navigator/tab_items.dart';
import 'package:conduit/ui/add_article/add_article_screen.dart';
import 'package:conduit/ui/base/base_screen.dart';
import 'package:conduit/ui/comments/comments_screen.dart';
import 'package:conduit/ui/tag_screen/tag_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/functions.dart';
import 'package:conduit/utils/image_string.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/utils/route_transition.dart';
import 'package:conduit/widget/no_internet.dart';
import 'package:conduit/widget/theme_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class GlobalItemDetailScreen extends StatefulWidget {
  static const globalItemDetailUrl = '/globalItemDetail';
  GlobalItemDetailScreen({
    Key? key,
    required this.slug,
    required this.favorited,
    this.username,
    required this.isFollowed,
  }) : super(key: key);
  // AllArticlesModel? allArticlesModel;
  String slug;
  String? username;
  bool favorited;
  bool isFollowed;

  @override
  State<GlobalItemDetailScreen> createState() => _GlobalItemDetailScreenState();
}

class _GlobalItemDetailScreenState extends State<GlobalItemDetailScreen> {
  Timer? timer;
  bool? _isFollow;
  bool? _isLike;
  bool isDeleting = false;
  bool isNoInternet = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // bool comment = false;
  // TextEditingController? commentCtr;
  // late AddCommentBloc addCommentBloc;
  // late CommentBloc commentBloc;
  late FollowBloc followBloc;
  String? dataUsername;
  bool isUsername = false;
  late ArticleBloc articleBloc;
  late LikeBloc likeBloc;

  void initState() {
    super.initState();

    fetchdata();

    articleBloc = context.read<ArticleBloc>();
    articleBloc.add(FetchArticleEvent(slug: widget.slug));

    likeBloc = context.read<LikeBloc>();
    _isLike = widget.favorited;

    followBloc = context.read<FollowBloc>();
    _isFollow = widget.isFollowed;
  }

  void fetchdata() async {
    Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
    dataUsername = detailModel!.values.first.userName!;
    setState(() {
      isUsername = true;
    });
  }

  onRetryData() {
    setState(() {
      isNoInternet = false;
      articleBloc.add(FetchArticleEvent(slug: widget.slug));
    });
  }

  changeFollowState() {
    setState(() {
      _isFollow = !_isFollow!;
      if (_isFollow!) {
        followBloc.add(FollowUserEvent(username: widget.username));
      } else {
        followBloc.add(UnFollowUserEvent(username: widget.username));
      }
    });
  }

  changeLikeState() {
    setState(() {
      _isLike = !_isLike!;
      if (_isLike!) {
        likeBloc.add(LikeArticleEvent(slug: widget.slug));
      } else {
        likeBloc.add(RemoveLikeArticleEvent(slug: widget.slug));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            // centerTitle: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                ic_back_arrow_icon,
                color: AppColors.white,
              ),
            ),
            title: Text(
              "Details",
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontFamily: ConduitFontFamily.robotoRegular),
            ),
          ),
          body: ThemeContainer(
            child: isNoInternet
                ? NoInternet(
                    onClickRetry: onRetryData,
                  )
                : SafeArea(
                    child: BlocConsumer<ArticleBloc, ArticleState>(
                    listener: (context, state) {
                      if (state is ArticleErrorState) {
                        CToast.instance.showError(context, state.msg);
                      }
                      if (state is ArticleNoInternetState) {
                        setState(() {
                          isNoInternet = true;
                        });
                      }
                      if (state is ArticleDeleteSuccessState) {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        print("====================================================");
                        // globalNavigationKey.currentState?.push(
                        //   SlideRightRoute(
                        //     page: BaseScreen(),
                        //     settings: (RouteSettings(
                        //       arguments: {},
                        //       name: BaseScreen.baseUrl,
                        //     )),
                        //   ),
                        // )
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BaseScreen(),
                          ),
                        );
                        // BaseScreen.switchTab(
                        //   context,
                        //   MyTabItem.globalfeed,
                        // );
                      }
                    },
                    builder: (context, state) {
                      if (state is ArticleLoadingState) {
                        return Center(child: CToast.instance.showLoader());
                      }
                      if (state is ArticleLoadedState) {
                        return ScrollConfiguration(
                          behavior: NoGlow(),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              '${state.articleModel.last.article?.title}',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 19.0,
                                                  wordSpacing: 2,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.black,
                                                  fontFamily: ConduitFontFamily
                                                      .robotoBold),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: CircleAvatar(
                                                        radius: 22,
                                                        backgroundColor: AppColors
                                                            .Bottom_bar_color,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          child: Image.network(
                                                            "${state.articleModel.last.article?.author?.image}",
                                                            scale: 0.01,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
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
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "${state.articleModel.last.article?.author?.username.toString()}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            ConduitFontFamily
                                                                                .robotoRegular,
                                                                        color: AppColors
                                                                            .primaryColor),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                    ),
                                                                    child:
                                                                        SizedBox(
                                                                      child:
                                                                          CircleAvatar(
                                                                        radius:
                                                                            1.5,
                                                                        backgroundColor: AppColors
                                                                            .black
                                                                            .withOpacity(0.5),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                            50,
                                                                          ),
                                                                          child:
                                                                              Container(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap:
                                                                        changeFollowState,
                                                                    child:
                                                                        AnimatedSwitcher(
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              200),
                                                                      switchInCurve:
                                                                          Curves
                                                                              .easeOut,
                                                                      switchOutCurve:
                                                                          Curves
                                                                              .easeOut,
                                                                      transitionBuilder: (Widget
                                                                              child,
                                                                          Animation<double>
                                                                              animation) {
                                                                        return ScaleTransition(
                                                                          scale:
                                                                              animation,
                                                                          child:
                                                                              child,
                                                                        );
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Center(
                                                                          child: _isFollow!
                                                                              ? Text(
                                                                                  "Following",
                                                                                  style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    fontFamily: ConduitFontFamily.robotoRegular,
                                                                                    color: AppColors.black.withOpacity(0.8),
                                                                                  ),
                                                                                )
                                                                              : Text(
                                                                                  "Follow",
                                                                                  style: TextStyle(
                                                                                    color: AppColors.black.withOpacity(0.8),
                                                                                    fontFamily: ConduitFontFamily.robotoRegular,
                                                                                  ),
                                                                                ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: Text(
                                                                DateFormat(
                                                                        'dd-MM-yyyy')
                                                                    .format(
                                                                  DateTime
                                                                      .parse(
                                                                    state
                                                                        .articleModel
                                                                        .last
                                                                        .article!
                                                                        .createdAt
                                                                        .toString()
                                                                        .trimLeft(),
                                                                  ),
                                                                ),
                                                                // "${widget.allArticlesModel?.createdAt.toString().trimLeft()}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontFamily:
                                                                        ConduitFontFamily
                                                                            .robotoRegular,
                                                                    color: AppColors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.8)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Divider(
                                              color: AppColors.text_color,
                                            ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    changeLikeState();
                                                    setState(() {
                                                      if (_isLike!) {
                                                        state
                                                            .articleModel
                                                            .last
                                                            .article!
                                                            .favoritesCount = (state
                                                                    .articleModel
                                                                    .last
                                                                    .article!
                                                                    .favoritesCount! +
                                                                1)
                                                            .toInt();
                                                        print(state
                                                            .articleModel
                                                            .last
                                                            .article!
                                                            .favoritesCount!
                                                            .toInt());
                                                      } else {
                                                        state
                                                            .articleModel
                                                            .last
                                                            .article!
                                                            .favoritesCount = (state
                                                                    .articleModel
                                                                    .last
                                                                    .article!
                                                                    .favoritesCount! -
                                                                1)
                                                            .toInt();
                                                        print(state
                                                            .articleModel
                                                            .last
                                                            .article!
                                                            .favoritesCount!
                                                            .toInt());
                                                      }
                                                    });
                                                  },
                                                  child: AnimatedSwitcher(
                                                    duration: Duration(
                                                        milliseconds: 200),
                                                    switchInCurve:
                                                        Curves.easeOut,
                                                    switchOutCurve:
                                                        Curves.easeOut,
                                                    transitionBuilder:
                                                        (Widget child,
                                                            Animation<double>
                                                                animation) {
                                                      return ScaleTransition(
                                                        scale: animation,
                                                        child: child,
                                                      );
                                                    },
                                                    child: _isLike!
                                                        ? Icon(
                                                            Icons.favorite,
                                                            size: 25,
                                                            color: AppColors
                                                                .primaryColor,
                                                            key: ValueKey<int>(
                                                                1),
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .favorite_outline,
                                                            color: AppColors
                                                                .text_color,
                                                            size: 25,
                                                            key: ValueKey<int>(
                                                                2),
                                                          ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "${state.articleModel.last.article!.favoritesCount!.toInt()}",
                                                  style: TextStyle(
                                                    color: AppColors.text_color,
                                                    fontSize: 13,
                                                    fontFamily:
                                                        ConduitFontFamily
                                                            .robotoRegular,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context,
                                                        CommentsScreen
                                                            .commentUrl,
                                                        arguments: {
                                                          'slug': widget.slug,
                                                        });
                                                    // Navigator.push(
                                                    //   context,
                                                    //   CupertinoPageRoute(
                                                    //     builder: (context) {
                                                    //       return CommentsScreen(
                                                    //         slug: widget.slug,
                                                    //       );
                                                    //     },
                                                    //   ),
                                                    // );
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      // color: AppColors
                                                      //     .Bottom_bar_color,
                                                    ),
                                                    child: Icon(
                                                      Icons.comment,
                                                      color:
                                                          AppColors.text_color,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Spacer(),
                                                if (dataUsername ==
                                                    state
                                                        .articleModel
                                                        .last
                                                        .article
                                                        ?.author!
                                                        .username)
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          if (isNoInternet) {
                                                            CToast.instance
                                                                .showError(
                                                                    context,
                                                                    NO_INTERNET);
                                                          } else {
                                                            Navigator.pushNamed(
                                                                context,
                                                                AddArticleScreen
                                                                    .addArticleUrl,
                                                                arguments: {
                                                                  'slug': state
                                                                      .articleModel
                                                                      .last
                                                                      .article!
                                                                      .slug!,
                                                                  'isUpdateArticle':
                                                                      true,
                                                                });
                                                          }
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Icon(
                                                            Icons.edit,
                                                            color: AppColors
                                                                .text_color,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          showAlertBottomSheet();
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            // color: AppColors
                                                            //     .Bottom_bar_color,
                                                          ),
                                                          child: Icon(
                                                            Icons.delete,
                                                            color:
                                                                Colors.red[400],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                            Divider(
                                              color: AppColors.text_color,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.0),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 10,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        "${state.articleModel.last.article?.body?.replaceAll('\\n', '\n\n')}",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          wordSpacing: 1,
                                          fontFamily:
                                              ConduitFontFamily.robotoLight,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: List.generate(
                                          state.articleModel.last.article!
                                              .tagList!.length,
                                          (index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, TagScreen.tagUrl,
                                                    arguments: {
                                                      'title': state
                                                          .articleModel
                                                          .last
                                                          .article
                                                          ?.tagList![index],
                                                    });
                                                // Navigator.push(
                                                //   context,
                                                //   CupertinoPageRoute(
                                                //     builder: (context) {
                                                //       return BlocProvider(
                                                //         create: (context) =>
                                                //             TagsBloc(
                                                //                 repo:
                                                //                     AllArticlesImpl()), // Create a new instance
                                                //         child: TagScreen(
                                                //           title: state
                                                //               .articleModel
                                                //               .last
                                                //               .article
                                                //               ?.tagList![index],
                                                //         ),
                                                //       );
                                                //     },
                                                //   ),
                                                // );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade600,
                                                  // border: Border.all(
                                                  //   color:
                                                  //       AppColors.black.withOpacity(1),
                                                  // ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 5,
                                                    horizontal: 10,
                                                  ),
                                                  child: Text(
                                                    "${state.articleModel.last.article?.tagList![index]}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: AppColors.white,
                                                      fontFamily:
                                                          ConduitFontFamily
                                                              .robotoRegular,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: EdgeInsets.only(
                                    //       left: 15, right: 15, bottom: 5),
                                    //   child: Divider(),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(
                                    //       left: 15, right: 15, bottom: 10),
                                    //   child: Row(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     crossAxisAlignment: CrossAxisAlignment.center,
                                    //     children: [
                                    //       Row(
                                    //         children: [
                                    //           Align(
                                    //             alignment: Alignment.centerLeft,
                                    //             child: CircleAvatar(
                                    //               radius: 15,
                                    //               child: ClipRRect(
                                    //                 borderRadius:
                                    //                     BorderRadius.circular(50),
                                    //                 child: Image.network(
                                    //                     "${state.articleModel.last.article?.author?.image}"),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //           Padding(
                                    //             padding: const EdgeInsets.only(
                                    //               left: 10,
                                    //             ),
                                    //             child: Container(
                                    //               child: Column(
                                    //                 mainAxisAlignment:
                                    //                     MainAxisAlignment.center,
                                    //                 crossAxisAlignment:
                                    //                     CrossAxisAlignment.start,
                                    //                 children: [
                                    //                   Align(
                                    //                       alignment: Alignment.topLeft,
                                    //                       child: Text(
                                    //                         "${state.articleModel.last.article?.author?.username.toString()}",
                                    //                         style: TextStyle(
                                    //                             fontSize: 13,
                                    //                             color: AppColors
                                    //                                 .primaryColor),
                                    //                       )),
                                    //                   Align(
                                    //                     alignment: Alignment.bottomLeft,
                                    //                     child: Text(
                                    //                       DateFormat('dd-MM-yyyy')
                                    //                           .format(
                                    //                         DateTime.parse(
                                    //                           state.articleModel.last
                                    //                               .article!.createdAt
                                    //                               .toString()
                                    //                               .trimLeft(),
                                    //                         ),
                                    //                       ),
                                    //                       // "${widget.allArticlesModel?.createdAt.toString().trimLeft()}",
                                    //                       style: TextStyle(
                                    //                           fontSize: 9,
                                    //                           color:
                                    //                               AppColors.text_color),
                                    //                     ),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //       Spacer(),
                                    //       GestureDetector(
                                    //         onTap: changeFollowState,
                                    //         child: AnimatedSwitcher(
                                    //           duration: Duration(milliseconds: 200),
                                    //           switchInCurve: Curves.easeOut,
                                    //           switchOutCurve: Curves.easeOut,
                                    //           transitionBuilder: (Widget child,
                                    //               Animation<double> animation) {
                                    //             return ScaleTransition(
                                    //               scale: animation,
                                    //               child: child,
                                    //             );
                                    //           },
                                    //           child: Container(
                                    //             padding: EdgeInsets.symmetric(
                                    //                 horizontal: 10),
                                    //             height: 22,
                                    //             decoration: BoxDecoration(
                                    //                 borderRadius:
                                    //                     BorderRadius.circular(5),
                                    //                 border: Border.all(
                                    //                     color: AppColors.black
                                    //                         .withOpacity(0.5))),
                                    //             child: Center(
                                    //               child: _isFollow!
                                    //                   ? Text(
                                    //                       "Following",
                                    //                       style:
                                    //                           TextStyle(fontSize: 14),
                                    //                     )
                                    //                   : Text(
                                    //                       "Follow",
                                    //                     ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //       // Container(
                                    //       //   decoration: BoxDecoration(
                                    //       //       borderRadius: BorderRadius.circular(5),
                                    //       //       border: Border.all(
                                    //       //           color: AppColors.text_color)),
                                    //       //   child: Padding(
                                    //       //     padding: const EdgeInsets.symmetric(
                                    //       //         vertical: 2, horizontal: 10),
                                    //       //     child: Text(
                                    //       //       "${state.articleModel.last.article?.author?.following}",
                                    //       //       style: TextStyle(
                                    //       //           color: AppColors.text_color,
                                    //       //           fontSize: 14),
                                    //       //     ),
                                    //       //   ),
                                    //       // ),
                                    //       SizedBox(
                                    //         width: 10,
                                    //       ),
                                    //       // Container(
                                    //       //   decoration: BoxDecoration(
                                    //       //       borderRadius: BorderRadius.circular(5),
                                    //       //       border: Border.all(
                                    //       //           color: AppColors.primaryColor)),
                                    //       //   child: Padding(
                                    //       //     padding: const EdgeInsets.symmetric(
                                    //       //         vertical: 2, horizontal: 7),
                                    //       //     child: Row(
                                    //       //       children: [
                                    //       //         Icon(
                                    //       //           Icons.favorite,
                                    //       //           size: 16,
                                    //       //           color: AppColors.primaryColor,
                                    //       //         ),
                                    //       //         SizedBox(
                                    //       //           width: 5,
                                    //       //         ),
                                    //       //         Text(
                                    //       //           "( ${state.articleModel.last.article!.favoritesCount} )",
                                    //       //           style: TextStyle(
                                    //       //               color: AppColors.primaryColor,
                                    //       //               fontSize: 14),
                                    //       //         ),
                                    //       //       ],
                                    //       //     ),
                                    //       //   ),
                                    //       // ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // BlocListener<AddCommentBloc, AddCommentState>(
                                    //   listener: (context, state) {
                                    //     if (state is AddCommentLoadingState) {}
                                    //     if (state is AddCommentErroeState) {
                                    //       Navigator.pop(context);
                                    //       formKey.currentState!.reset();
                                    //       Future.delayed(Duration.zero, () {
                                    //         CToast.instance
                                    //             .showError(context, state.msg);
                                    //       });
                                    //     }
                                    //     if (state is AddCommentSuccessState) {
                                    //       commentCtr!.clear();
                                    //       formKey.currentState!.reset();
                                    //       Navigator.pop(context);
                                    //       refreshComments();
                                    //     }
                                    //   },
                                    //   child: Padding(
                                    //     padding:
                                    //         const EdgeInsets.only(left: 15, right: 15),
                                    //     child: Container(
                                    //       decoration: BoxDecoration(
                                    //         borderRadius: BorderRadius.circular(5),
                                    //         border: Border.all(
                                    //           color: AppColors.black.withOpacity(0.5),
                                    //         ),
                                    //       ),
                                    //       child: Form(
                                    //         key: formKey,
                                    //         autovalidateMode:
                                    //             AutovalidateMode.onUserInteraction,
                                    //         child: Column(
                                    //           children: [
                                    //             TextFormField(
                                    //               maxLines: 3,
                                    //               controller: commentCtr,
                                    //               cursorColor: AppColors.primaryColor,
                                    //               keyboardType: TextInputType.text,
                                    //               style: TextStyle(
                                    //                 color: Colors.black,
                                    //               ),
                                    //               validator: (value) {
                                    //                 if (value!.length <= 0) {
                                    //                   return "Write something";
                                    //                 }
                                    //               },
                                    //               decoration: InputDecoration(
                                    //                 hintText: "Write a comment...",
                                    //                 filled: true,
                                    //                 enabled: true,
                                    //                 fillColor: AppColors.white2,
                                    //                 contentPadding:
                                    //                     const EdgeInsets.all(10),
                                    //                 prefixIcon: Padding(
                                    //                   padding:
                                    //                       const EdgeInsets.all(15.0),
                                    //                 ),
                                    //                 border: OutlineInputBorder(
                                    //                     borderRadius:
                                    //                         BorderRadius.circular(10)),
                                    //                 disabledBorder: OutlineInputBorder(
                                    //                   borderSide: BorderSide(
                                    //                       width: 3,
                                    //                       color: AppColors.white2),
                                    //                   borderRadius:
                                    //                       BorderRadius.circular(10),
                                    //                 ),
                                    //                 focusedBorder: OutlineInputBorder(
                                    //                   borderSide: BorderSide(
                                    //                       width: 3,
                                    //                       color: AppColors.white2),
                                    //                   borderRadius:
                                    //                       BorderRadius.circular(10),
                                    //                 ),
                                    //                 enabledBorder: OutlineInputBorder(
                                    //                   borderSide: BorderSide(
                                    //                       width: 3,
                                    //                       color: AppColors.white2),
                                    //                   borderRadius:
                                    //                       BorderRadius.circular(10),
                                    //                 ),
                                    //                 errorBorder: OutlineInputBorder(
                                    //                   borderSide: BorderSide(
                                    //                       width: 3,
                                    //                       color: AppColors.white2),
                                    //                   borderRadius:
                                    //                       BorderRadius.circular(10),
                                    //                 ),
                                    //                 focusedErrorBorder:
                                    //                     OutlineInputBorder(
                                    //                   borderSide: BorderSide(
                                    //                       width: 3,
                                    //                       color: AppColors.white2),
                                    //                   borderRadius:
                                    //                       BorderRadius.circular(10),
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //             Divider(
                                    //               color:
                                    //                   AppColors.black.withOpacity(0.5),
                                    //             ),
                                    //             Container(
                                    //               decoration: BoxDecoration(
                                    //                 borderRadius:
                                    //                     BorderRadius.circular(5),
                                    //               ),
                                    //               child: Padding(
                                    //                 padding: const EdgeInsets.symmetric(
                                    //                     vertical: 3, horizontal: 8),
                                    //                 child: Row(
                                    //                   children: [
                                    //                     CircleAvatar(
                                    //                       radius: 15,
                                    //                       child: ClipRRect(
                                    //                         borderRadius:
                                    //                             BorderRadius.circular(
                                    //                                 50),
                                    //                         child: Image.network(
                                    //                             "${state.articleModel.last.article!.author?.image}"),
                                    //                       ),
                                    //                     ),
                                    //                     Spacer(),
                                    //                     Container(
                                    //                       height: 30,
                                    //                       decoration: BoxDecoration(
                                    //                         color:
                                    //                             AppColors.primaryColor,
                                    //                         borderRadius:
                                    //                             BorderRadius.circular(
                                    //                                 5),
                                    //                       ),
                                    //                       child: MaterialButton(
                                    //                         onPressed: () {
                                    //                           FocusManager
                                    //                               .instance.primaryFocus
                                    //                               ?.unfocus();
                                    //                           if (formKey.currentState!
                                    //                               .validate()) {
                                    //                             CToast.instance
                                    //                                 .showLoaderDialog(
                                    //                                     context);
                                    //                             addCommentBloc.add(
                                    //                               SubmitCommentEvent(
                                    //                                 addCommentModel:
                                    //                                     AddCommentModel(
                                    //                                   comment: Comment(
                                    //                                     body: commentCtr!
                                    //                                         .text
                                    //                                         .toString(),
                                    //                                   ),
                                    //                                 ),
                                    //                                 slug: state
                                    //                                     .articleModel
                                    //                                     .last
                                    //                                     .article!
                                    //                                     .slug,
                                    //                               ),
                                    //                             );
                                    //                           }
                                    //                         },
                                    //                         child: Text(
                                    //                           "Post Comment",
                                    //                           textAlign:
                                    //                               TextAlign.center,
                                    //                           style: TextStyle(
                                    //                             color: AppColors.white,
                                    //                             fontWeight:
                                    //                                 FontWeight.bold,
                                    //                           ),
                                    //                         ),
                                    //                       ),
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //             SizedBox(height: 10),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // BlocBuilder<CommentBloc, CommentState>(
                                    //   builder: (context, state) {
                                    //     if (state is CommentErrorState) {
                                    //       return CToast.instance
                                    //           .showError(context, state.msg);
                                    //     }
                                    //     if (state is CommentLoadingState) {
                                    //       return Padding(
                                    //         padding: const EdgeInsets.all(10),
                                    //         child: SizedBox(
                                    //           height: 30,
                                    //           child: CToast.instance.showLoader(),
                                    //         ),
                                    //       );
                                    //     }
                                    //     if (state is NoCommentState) {
                                    //       return SizedBox();
                                    //     }
                                    //     if (state is DeleteCommentSuccessState) {
                                    //       refreshComments();
                                    //     }
                                    //     if (state is CommentSuccessState) {
                                    //       return Padding(
                                    //         padding: const EdgeInsets.only(
                                    //             left: 15, right: 15, top: 10),
                                    //         child: ListView.separated(
                                    //           primary: false,
                                    //           shrinkWrap: true,
                                    //           reverse: true,
                                    //           scrollDirection: Axis.vertical,
                                    //           itemCount: state.commentModel.length,
                                    //           itemBuilder: (context, index) {
                                    //             return CommentWidget(
                                    //               slug: widget.slug,
                                    //               commentModel:
                                    //                   state.commentModel[index],
                                    //             );
                                    //           },
                                    //           separatorBuilder:
                                    //               (BuildContext context, int index) {
                                    //             return SizedBox(
                                    //               height: 10,
                                    //             );
                                    //           },
                                    //         ),
                                    //       );
                                    //     }
                                    //     return SizedBox();
                                    //   },
                                    // ),
                                  ],
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  )),
          ),
        ),
      ),
    );
  }

  Future<void> showAlertBottomSheet() {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          color: AppColors.black,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Text(
                  "Are you sure you want to delete the article?",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        height: 40,
                        color: AppColors.white,
                        disabledColor: AppColors.pholder_background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          'Cancel',
                          style: Theme.of(context)
                              .textTheme
                              .button
                              ?.copyWith(
                                fontFamily: ConduitFontFamily.robotoRegular,
                              )
                              .copyWith(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: MaterialButton(
                        height: 40,
                        color: Colors.red[400],
                        disabledColor: AppColors.Bottom_bar_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          'Confirm',
                          style: Theme.of(context)
                              .textTheme
                              .button
                              ?.copyWith(
                                fontFamily: ConduitFontFamily.robotoRegular,
                              )
                              .copyWith(color: AppColors.white),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          articleBloc.add(
                            DeleteArticleEvent(slug: widget.slug),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
