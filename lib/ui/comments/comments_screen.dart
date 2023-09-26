import 'package:conduit/bloc/add_comment_bloc/add_comment_bloc.dart';
import 'package:conduit/bloc/add_comment_bloc/add_comment_event.dart';
import 'package:conduit/bloc/add_comment_bloc/add_comment_state.dart';
import 'package:conduit/bloc/comment_bloc/comment_bloc.dart';
import 'package:conduit/bloc/comment_bloc/comment_event.dart';
import 'package:conduit/bloc/comment_bloc/comment_state.dart';
import 'package:conduit/config/constant.dart';
import 'package:conduit/main.dart';
import 'package:conduit/model/comment_model.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/functions.dart';
import 'package:conduit/utils/image_string.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/comment_widget.dart';
import 'package:conduit/widget/conduitEditText_widget.dart';
import 'package:conduit/widget/no_internet.dart';
import 'package:conduit/widget/theme_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CommentsScreen extends StatefulWidget {
  static const commentUrl = '/comment';
  CommentsScreen({Key? key, required this.slug}) : super(key: key);
  String slug;

  @override
  State<CommentsScreen> createState() => CommentsScreenState();
}

class CommentsScreenState extends State<CommentsScreen> {
  bool isNoInternet = false;
  late CommentBloc commentBloc;
  late AddCommentBloc addCommentBloc;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController? commentCtr;

  void initState() {
    super.initState();

    commentCtr = TextEditingController();
    addCommentBloc = context.read<AddCommentBloc>();

    commentBloc = context.read<CommentBloc>();
    commentBloc.add(fetchCommentEvent(slug: widget.slug));
  }

  void refreshComments() {
    commentBloc.add(fetchCommentEvent(slug: widget.slug));
  }

  onRetryData() {
    setState(() {
      isNoInternet = false;
      commentBloc.add(fetchCommentEvent(slug: widget.slug));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
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
          "Comments",
          style: TextStyle(
            fontFamily: ConduitFontFamily.robotoRegular,
          ),
        ),
        centerTitle: false,
      ),
      body: WillPopScope(
        onWillPop: () async => true,
        child: ThemeContainer(
          child: Column(
            children: [
              Expanded(
                child: isNoInternet
                    ? NoInternet(
                        isWidget: true,
                        onClickRetry: onRetryData,
                      )
                    : BlocConsumer<CommentBloc, CommentState>(
                        listener: (context, state) {
                          if (state is CommentNoInternetState) {
                            setState(() {
                              isNoInternet = true;
                            });
                          }
                          if (state is CommentDeleteLoadingState) {
                            CToast.instance.showLodingLoader(context);
                          }
                          if (state is CommentErrorState) {
                            CToast.instance.showError(context, state.msg);
                          }
                          if (state is DeleteCommentSuccessState) {
                            CToast.instance.dismiss();
                            refreshComments();
                          }
                        },
                        builder: (context, state) {
                          if (state is NoCommentState) {
                            return Center(
                              child: Text(
                                "No Comments",
                                style: TextStyle(
                                  fontFamily: ConduitFontFamily.robotoRegular,
                                ),
                              ),
                            );
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

                          if (state is CommentSuccessState) {
                            return ScrollConfiguration(
                              behavior: NoGlow(),
                              child: ListView.separated(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 15, left: 15, right: 15),
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: state.commentModel.length,
                                itemBuilder: (context, index) {
                                  return CommentWidget(
                                    slug: widget.slug,
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
                          return Container();
                        },
                      ),
              ),
              Column(
                children: [
                  BlocListener<AddCommentBloc, AddCommentState>(
                    listener: (context, state) {
                      if (state is AddCommentLoadingState) {
                        CToast.instance.showLodingLoader(context);
                      }
                      if (state is AddCommentNoInternetState) {
                        CToast.instance.dismiss();
                        CToast.instance.showError(context, NO_INTERNET);
                      }
                      if (state is AddCommentErroeState) {
                        CToast.instance.dismiss();
                        formKey.currentState!.reset();
                        Future.delayed(Duration.zero, () {
                          CToast.instance.showError(context, state.msg);
                        });
                      }
                      if (state is AddCommentSuccessState) {
                        commentCtr!.clear();
                        formKey.currentState!.reset();
                        CToast.instance.dismiss();
                        refreshComments();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(5),
                      //   border: Border.all(
                      //     color: AppColors.black.withOpacity(0.5),
                      //   ),
                      // ),
                      color: AppColors.white,
                      child: Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ConduitEditText(
                                    hint: "Comment",
                                    controller: commentCtr,
                                    minLines: 1,
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    if (commentCtr!.text != "") {
                                      addCommentBloc.add(
                                        SubmitCommentEvent(
                                          addCommentModel: AddCommentModel(
                                            comment: Comment(
                                              body: commentCtr!.text.toString(),
                                            ),
                                          ),
                                          slug: widget.slug,
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: 14,
                                      right: 10,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 2,
                                            blurStyle: BlurStyle.normal,
                                            color: AppColors.black_light.withOpacity(0.4)
                                          )
                                        ],
                                        color: AppColors.primaryColor),
                                    child: Icon(
                                      Icons.send,
                                      size: 20,
                                      color: AppColors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future showAlertBottomSheet() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Color.fromARGB(255, 19, 19, 19),
      builder: (context) {
        return IntrinsicHeight(
          child: SafeArea(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  BlocListener<AddCommentBloc, AddCommentState>(
                    listener: (context, state) {
                      if (state is AddCommentLoadingState) {}
                      if (state is AddCommentErroeState) {
                        CToast.instance.dismiss();
                        formKey.currentState!.reset();
                        Future.delayed(Duration.zero, () {
                          CToast.instance.showError(context, state.msg);
                        });
                      }
                      if (state is AddCommentSuccessState) {
                        commentCtr!.clear();
                        formKey.currentState!.reset();
                        CToast.instance.dismiss();
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                  contentPadding: const EdgeInsets.all(10),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: AppColors.white2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: AppColors.white2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: AppColors.white2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: AppColors.white2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: AppColors.white2),
                                    borderRadius: BorderRadius.circular(10),
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
                                      // CircleAvatar(
                                      //   radius: 15,
                                      //   child: ClipRRect(
                                      //     borderRadius:
                                      //         BorderRadius.circular(50),
                                      //     child: Image.network(
                                      //         "${state.articleModel.last.article!.author?.image}"),
                                      //   ),
                                      // ),
                                      Spacer(),
                                      Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: MaterialButton(
                                          onPressed: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            if (formKey.currentState!
                                                .validate()) {
                                              CToast.instance
                                                  .showLodingLoader(context);
                                              addCommentBloc.add(
                                                SubmitCommentEvent(
                                                  addCommentModel:
                                                      AddCommentModel(
                                                    comment: Comment(
                                                      body: commentCtr!.text
                                                          .toString(),
                                                    ),
                                                  ),
                                                  slug: widget.slug,
                                                ),
                                              );
                                            }
                                          },
                                          child: Text(
                                            "Post Comment",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: ConduitFontFamily
                                                  .robotoRegular,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
