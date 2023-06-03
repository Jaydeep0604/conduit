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
import 'package:conduit/config/hive_store.dart';
import 'package:conduit/model/comment_model.dart';
import 'package:conduit/model/user_model.dart';
import 'package:conduit/ui/home/home_screen.dart';
import 'package:conduit/ui/update_article/update_article.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/comment_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class GlobalItemDetailScreen extends StatefulWidget {
  GlobalItemDetailScreen(
      {Key? key, required this.slug, required this.favorited})
      : super(key: key);
  // AllArticlesModel? allArticlesModel;
  String slug;
  bool favorited;

  @override
  State<GlobalItemDetailScreen> createState() => _GlobalItemDetailScreenState();
}

class _GlobalItemDetailScreenState extends State<GlobalItemDetailScreen> {
  Timer? timer;
  bool comment = false;
  bool isLoading = false;
  bool isDeleting = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late AddCommentBloc addCommentBloc;
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

  @override
  Widget build(BuildContext context) {
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
                    child: widget.favorited
                        ? Icon(
                            Icons.favorite,
                            // size: 60,
                            color: AppColors.primaryColor,
                          )
                        : Icon(
                            Icons.favorite_border,
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
          child:
              BlocBuilder<ArticleBloc, ArticleState>(builder: (context, state) {
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         UserProfileDetailScreen(
                                        //       allArticlesModel:
                                        //           widget.allArticlesModel!,
                                        //     ),
                                        //   ),
                                        // );
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
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(DateTime
                                                              .parse(state
                                                                  .articleModel
                                                                  .last
                                                                  .article!
                                                                  .createdAt
                                                                  .toString()
                                                                  .trimLeft())),
                                                      // "${widget.allArticlesModel?.createdAt.toString().trimLeft()}",
                                                      style: TextStyle(
                                                          fontSize: 9,
                                                          color:
                                                              AppColors.white),
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
                                    if (dataUsername !=
                                        state.articleModel.last.article?.author!
                                            .username)
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: AppColors.white2)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.add,
                                                size: 15,
                                                color: AppColors.white2,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Follow",
                                                style: TextStyle(
                                                    color: AppColors.white2,
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (dataUsername ==
                                        state.articleModel.last.article?.author!
                                            .username)
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateArticleScreen(
                                                slug: state.articleModel.last
                                                    .article!.slug!,
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
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 15),
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
                                                  "Edit article",
                                                  style: TextStyle(
                                                      color: AppColors.white2,
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
                                        state.articleModel.last.article?.author!
                                            .username)
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: AppColors.primaryColor)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.favorite,
                                                size: 15,
                                                color: AppColors.primaryColor,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "( ${state.articleModel.last.article!.favoritesCount} )",
                                                style: TextStyle(
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (dataUsername ==
                                        state.articleModel.last.article?.author!
                                            .username)
                                      InkWell(
                                        onTap: () {
                                          showAlertBottomSheet();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.red.shade400)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 10),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  size: 16,
                                                  color: Colors.red.shade400,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.red.shade400,
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
                                itemCount: state
                                    .articleModel.last.article!.tagList!.length,
                                itemBuilder: (BuildContext ctxt, int index) {
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
                          padding:
                              EdgeInsets.only(left: 15, right: 15, bottom: 5),
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
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             UserProfileDetailScreen(
                                  //                 allArticlesModel: widget
                                  //                     .allArticlesModel!)));
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
                                                "${state.articleModel.last.article?.createdAt.toString().trimLeft()}",
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
                                        "( ${state.articleModel.last.article!.favoritesCount} )",
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
                        BlocListener<AddCommentBloc, AddCommentState>(
                          listener: (context, state) {
                            if (state is AddCommentLoadingState) {
                              setState(() {
                                isLoading = true;
                              });
                            }
                            if (state is AddCommentErroeState) {
                              isLoading = false;
                              Future.delayed(Duration.zero, () {
                                CToast.instance.showError(context, state.msg);
                              });
                            }
                            if (state is AddCommentSuccessState) {
                              commentCtr!.clear();
                              setState(() {
                                isLoading = false;
                              });
                              refreshComments();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: AppColors.black.withOpacity(0.5),
                                ),
                              ),
                              child: Form(
                                key: formKey,
                                autovalidateMode: AutovalidateMode.always,
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
                                      decoration: InputDecoration(
                                        hintText: "Write a comment...",
                                        filled: true,
                                        enabled: true,
                                        fillColor: AppColors.white2,
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(15.0),
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
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3,
                                              color: AppColors.white2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: AppColors.black.withOpacity(0.5),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
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
                                                    BorderRadius.circular(50),
                                                child: Image.network(
                                                    "${state.articleModel.last.article!.author?.image}"),
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              height: 30,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  if (formKey.currentState!
                                                      .validate()) {
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
                                                              .slug),
                                                    );
                                                  }
                                                },
                                                child: isLoading
                                                    ? CToast.instance
                                                        .showLoader()
                                                    : Text(
                                                        "Post Comment",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              AppColors.white,
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
                                      commentModel: state.commentModel[index],
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
    );
  }

  Future showAlertBottomSheet() {
    return showCupertinoModalPopup(
      context: context,
      // backgroundColor: Color.fromARGB(255, 19, 19, 19),
      builder: (context) {
        return IntrinsicHeight(
          child: SafeArea(
            child: Container(
              color: AppColors.black,
              child: Column(
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                              height: 40,
                              color: AppColors.white,
                              disabledColor: AppColors.pholder_background,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
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
                          child: FlatButton(
                            height: 40,
                            color: Colors.red[400],
                            // disabledColor: AppColors.Bottom_bar_color,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
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
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
