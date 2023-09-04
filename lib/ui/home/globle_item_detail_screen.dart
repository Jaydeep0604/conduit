import 'dart:async';
import 'package:conduit/bloc/add_comment_bloc/add_comment_bloc.dart';
import 'package:conduit/bloc/add_comment_bloc/add_comment_event.dart';
import 'package:conduit/bloc/add_comment_bloc/add_comment_state.dart';
import 'package:conduit/bloc/article_bloc/article_bloc.dart';
import 'package:conduit/bloc/article_bloc/article_event.dart';
import 'package:conduit/bloc/article_bloc/article_state.dart';
import 'package:conduit/bloc/comment_bloc/comment_bloc.dart';
import 'package:conduit/bloc/comment_bloc/comment_event.dart';
import 'package:conduit/bloc/comment_bloc/comment_state.dart';
import 'package:conduit/bloc/follow_bloc/follow_bloc.dart';
import 'package:conduit/bloc/follow_bloc/follow_event.dart';
import 'package:conduit/config/hive_store.dart';
import 'package:conduit/model/comment_model.dart';
import 'package:conduit/model/user_model.dart';
import 'package:conduit/ui/home/home_screen.dart';
import 'package:conduit/ui/update_article/update_article.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/comment_widget.dart';
import 'package:conduit/widget/theme_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class GlobalItemDetailScreen extends StatefulWidget {
  GlobalItemDetailScreen(
      {Key? key,
      required this.slug,
      required this.favorited,
      this.username,
      required this.isFollowed})
      : super(key: key);
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
  bool comment = false;
  bool? _isFollow;
  bool isDeleting = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late AddCommentBloc addCommentBloc;
  late FollowBloc followBloc;
  TextEditingController? commentCtr;
  String? dataUsername;
  bool isUsername = false;
  late CommentBloc commentBloc;
  late ArticleBloc articleBloc;

  void initState() {
    super.initState();

    fetchdata();

    articleBloc = context.read<ArticleBloc>();
    articleBloc.add(FetchArticleEvent(slug: widget.slug));

    commentCtr = TextEditingController();
    addCommentBloc = context.read<AddCommentBloc>();

    commentBloc = context.read<CommentBloc>();
    commentBloc.add(fetchCommentEvent(slug: widget.slug));

    followBloc = context.read<FollowBloc>();
    _isFollow = widget.isFollowed;
  }

  void refreshComments() {
    commentBloc.add(fetchCommentEvent(slug: widget.slug));
  }

  void fetchdata() async {
    Box<UserAccessData>? detailModel = await hiveStore.isExistUserAccessData();
    dataUsername = detailModel!.values.first.userName!;
    setState(() {
      isUsername = true;
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
                icon: Icon(Icons.arrow_back)),
            title: Text(
              "Details",
              style: TextStyle(color: AppColors.white, fontSize: 20),
            ),
          ),
          body: ThemeContainer(
            child: SafeArea(
              child: BlocBuilder<ArticleBloc, ArticleState>(
                  builder: (context, state) {
                if (state is ArticleLoadingState) {
                  return Center(child: CToast.instance.showLoader());
                }
                if (state is ArticleErrorState) {
                  return Center(
                    child: CToast.instance.showError(context, state.msg),
                  );
                }
                if (state is ArticleLoadedState) {
                  return SingleChildScrollView(
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
                                      "${state.articleModel.last.article?.title}",
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
                                        Row(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: CircleAvatar(
                                                radius: 15,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.network(
                                                      "${state.articleModel.last.article?.author?.image}"),
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
                                                          "${state.articleModel.last.article?.author?.username.toString()}",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: AppColors
                                                                  .primaryColor),
                                                        )),
                                                    Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Text(
                                                        DateFormat('dd-MM-yyyy')
                                                            .format(
                                                          DateTime.parse(
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
                                        Spacer(),
                                        // if (dataUsername !=
                                        //     state.articleModel.last.article
                                        //         ?.author!.username)
                                        //   Container(
                                        //     decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(5),
                                        //         border: Border.all(
                                        //             color: AppColors.white2)),
                                        //     child: Padding(
                                        //       padding:
                                        //           const EdgeInsets.symmetric(
                                        //               vertical: 2,
                                        //               horizontal: 10),
                                        //       child: Row(
                                        //         children: [
                                        //           Icon(
                                        //             Icons.add,
                                        //             size: 15,
                                        //             color: AppColors.white2,
                                        //           ),
                                        //           SizedBox(
                                        //             width: 5,
                                        //           ),
                                        //           Text(
                                        //             "Follow",
                                        //             style: TextStyle(
                                        //                 color: AppColors.white2,
                                        //                 fontSize: 13),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ),
                                        if (dataUsername ==
                                            state.articleModel.last.article
                                                ?.author!.username)
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      UpdateArticleScreen(
                                                    slug: state.articleModel
                                                        .last.article!.slug!,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: AppColors.white2)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2,
                                                        horizontal: 15),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.edit,
                                                      size: 15,
                                                      color: AppColors.white2,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "Edit",
                                                      style: TextStyle(
                                                          color:
                                                              AppColors.white2,
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        if (dataUsername !=
                                            state.articleModel.last.article
                                                ?.author!.username)
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: AppColors
                                                        .primaryColor)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 10),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.favorite,
                                                    size: 15,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "( ${state.articleModel.last.article!.favoritesCount} )",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontSize: 13),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (dataUsername ==
                                            state.articleModel.last.article
                                                ?.author!.username)
                                          InkWell(
                                            onTap: () {
                                              showAlertBottomSheet();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color:
                                                          Colors.red.shade400)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2,
                                                        horizontal: 10),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      size: 16,
                                                      color:
                                                          Colors.red.shade400,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .red.shade400,
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
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
                                "${state.articleModel.last.article?.body}",
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ),
                            if (state
                                .articleModel.last.article!.tagList!.isNotEmpty)
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
                                    itemCount: state.articleModel.last.article!
                                        .tagList!.length,
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
                                              " ${state.articleModel.last.article?.tagList?[index]} ",
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
                                  Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: CircleAvatar(
                                          radius: 15,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.network(
                                                "${state.articleModel.last.article?.author?.image}"),
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
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    "${state.articleModel.last.article?.author?.username.toString()}",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: AppColors
                                                            .primaryColor),
                                                  )),
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text(
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(
                                                    DateTime.parse(
                                                      state.articleModel.last
                                                          .article!.createdAt
                                                          .toString()
                                                          .trimLeft(),
                                                    ),
                                                  ),
                                                  // "${widget.allArticlesModel?.createdAt.toString().trimLeft()}",
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      color:
                                                          AppColors.text_color),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: changeFollowState,
                                    child: AnimatedSwitcher(
                                      duration: Duration(milliseconds: 200),
                                      switchInCurve: Curves.easeOut,
                                      switchOutCurve: Curves.easeOut,
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        return ScaleTransition(
                                          scale: animation,
                                          child: child,
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        height: 22,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: AppColors.black
                                                    .withOpacity(0.5))),
                                        child: Center(
                                          child: _isFollow!
                                              ? Text(
                                                  "Following",
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                )
                                              : Text(
                                                  "Follow",
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(5),
                                  //       border: Border.all(
                                  //           color: AppColors.text_color)),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.symmetric(
                                  //         vertical: 2, horizontal: 10),
                                  //     child: Text(
                                  //       "${state.articleModel.last.article?.author?.following}",
                                  //       style: TextStyle(
                                  //           color: AppColors.text_color,
                                  //           fontSize: 14),
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(5),
                                  //       border: Border.all(
                                  //           color: AppColors.primaryColor)),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.symmetric(
                                  //         vertical: 2, horizontal: 7),
                                  //     child: Row(
                                  //       children: [
                                  //         Icon(
                                  //           Icons.favorite,
                                  //           size: 16,
                                  //           color: AppColors.primaryColor,
                                  //         ),
                                  //         SizedBox(
                                  //           width: 5,
                                  //         ),
                                  //         Text(
                                  //           "( ${state.articleModel.last.article!.favoritesCount} )",
                                  //           style: TextStyle(
                                  //               color: AppColors.primaryColor,
                                  //               fontSize: 14),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            BlocListener<AddCommentBloc, AddCommentState>(
                              listener: (context, state) {
                                if (state is AddCommentLoadingState) {}
                                if (state is AddCommentErroeState) {
                                  Navigator.pop(context);
                                  formKey.currentState!.reset();
                                  Future.delayed(Duration.zero, () {
                                    CToast.instance
                                        .showError(context, state.msg);
                                  });
                                }
                                if (state is AddCommentSuccessState) {
                                  commentCtr!.clear();
                                  formKey.currentState!.reset();
                                  Navigator.pop(context);
                                  refreshComments();
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: AppColors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Form(
                                    key: formKey,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          maxLines: 3,
                                          controller: commentCtr,
                                          cursorColor: AppColors.primaryColor,
                                          keyboardType: TextInputType.text,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                          validator: (value) {
                                            if (value!.length <= 0) {
                                              return "Write something";
                                            }
                                          },
                                          decoration: InputDecoration(
                                            hintText: "Write a comment...",
                                            filled: true,
                                            enabled: true,
                                            fillColor: AppColors.white2,
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color:
                                              AppColors.black.withOpacity(0.5),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 8),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 15,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Image.network(
                                                        "${state.articleModel.last.article!.author?.image}"),
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppColors.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: MaterialButton(
                                                    onPressed: () {
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                      if (formKey.currentState!
                                                          .validate()) {
                                                        CToast.instance
                                                            .showLoaderDialog(
                                                                context);
                                                        addCommentBloc.add(
                                                          SubmitCommentEvent(
                                                            addCommentModel:
                                                                AddCommentModel(
                                                              comment: Comment(
                                                                body: commentCtr!
                                                                    .text
                                                                    .toString(),
                                                              ),
                                                            ),
                                                            slug: state
                                                                .articleModel
                                                                .last
                                                                .article!
                                                                .slug,
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Text(
                                                      "Post Comment",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: AppColors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            BlocBuilder<CommentBloc, CommentState>(
                              builder: (context, state) {
                                if (state is CommentErrorState) {
                                  return CToast.instance
                                      .showError(context, state.msg);
                                }
                                if (state is CommentLoadingState) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SizedBox(
                                      height: 30,
                                      child: CToast.instance.showLoader(),
                                    ),
                                  );
                                }
                                if (state is NoCommentState) {
                                  return SizedBox();
                                }
                                if (state is DeleteCommentSuccessState) {
                                  refreshComments();
                                }
                                if (state is CommentSuccessState) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 10),
                                    child: ListView.separated(
                                      primary: false,
                                      shrinkWrap: true,
                                      reverse: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: state.commentModel.length,
                                      itemBuilder: (context, index) {
                                        return CommentWidget(
                                          slug: widget.slug,
                                          commentModel:
                                              state.commentModel[index],
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          height: 10,
                                        );
                                      },
                                    ),
                                  );
                                }
                                return SizedBox();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  );
                }
                return SizedBox();
              }),
            ),
          ),
        ),
      ),
    );
  }

  Future showAlertBottomSheet() {
    return showCupertinoModalPopup(
      context: context,
      // backgroundColor: Color.fromARGB(255, 19, 19, 19),
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
                  "Are you sure you want to delete article?",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: AppColors.white,
                        // fontFamily: KSMFontFamily.robotoThin,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Expanded(
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
                            child: new Text('Cancel',
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    ?.copyWith(
                                        // fontFamily: KSMFontFamily.robotoRgular
                                        )
                                    .copyWith(color: Colors.black)),
                            onPressed: () {
                              Navigator.pop(context, false);
                            }),
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
                          child: new Text(
                            'Confirm',
                            style: Theme.of(context)
                                .textTheme
                                .button
                                ?.copyWith(
                                    //fontFamily: KSMFontFamily.robotoRgular
                                    )
                                .copyWith(color: AppColors.white),
                          ),
                          onPressed: () async {
                            articleBloc.add(
                              DeleteArticleEvent(slug: widget.slug),
                            );
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                            Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => HomeScreen()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
