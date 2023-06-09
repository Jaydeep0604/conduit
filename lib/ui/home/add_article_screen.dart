import 'package:conduit/bloc/article_bloc/article_bloc.dart';
import 'package:conduit/bloc/article_bloc/article_event.dart';
import 'package:conduit/bloc/article_bloc/article_state.dart';
import 'package:conduit/bloc/new_article_bloc/new_article_bloc.dart';
import 'package:conduit/bloc/new_article_bloc/new_article_event.dart';
import 'package:conduit/bloc/new_article_bloc/new_article_state.dart';
import 'package:conduit/model/new_article_model.dart';
import 'package:conduit/ui/home/home_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddArticleScreen extends StatefulWidget {
  AddArticleScreen({Key? key}) : super(key: key);
  // bool isAddArticle;
  // String slug;

  @override
  State<AddArticleScreen> createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController? titleCtr;
  TextEditingController? aboutTitleCtr;
  TextEditingController? articleCtr;
  TextEditingController? tagsCtr;
  late ArticleBloc articleBloc;
  // List<ArticleModel>? articleModel;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    articleBloc = context.read<ArticleBloc>();
    titleCtr = TextEditingController();
    aboutTitleCtr = TextEditingController();
    articleCtr = TextEditingController();
    tagsCtr = TextEditingController();
  }

  void clear() {
    setState(() {
      titleCtr!.clear();
      aboutTitleCtr!.clear();
      articleCtr!.clear();
      tagsCtr!.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.white2,
        body: SafeArea(
          child: BlocListener<ArticleBloc, ArticleState>(
            listener: (context, state) {
              if (state is ArticleLoadingState) {
                setState(() {
                  isLoading = true;
                });
                CToast.instance.showLoading(context);
              } else {
                setState(() {
                  isLoading = false;
                });
                CToast.instance.dismiss();
              }

              if (state is ArticleAddSuccessState) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
                clear();
                CToast.instance.showSuccess(context, state.msg);
              }

              if (state is ArticleAddErrorState) {
                CToast.instance.showError(context, state.msg);
              }
            },
            child: Form(
              key: _form,
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20.w, right: 20.w, left: 20.w),
                    child: Column(
                      children: [
                        TextFormField(
                          autofocus: false,
                          // initialValue: detail!.userName.toString(),
                          controller: titleCtr,
                          cursorColor: AppColors.primaryColor,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(150)
                          ],
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.white,
                              contentPadding:  EdgeInsets.all(10.w),
                              prefixIcon: Padding(
                                padding:  EdgeInsets.all(10.0.w),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Article Title"),
                          // controller: emailCtr,
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20.w, right: 20.w, left: 20.w),
                    child: Column(
                      children: [
                        TextFormField(
                          autofocus: false,
                          controller: aboutTitleCtr,
                          cursorColor: AppColors.primaryColor,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(150)
                          ],
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.white,
                              contentPadding: EdgeInsets.all(10.w),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(10.0.w),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "What's this article about?"),
                          // controller: emailCtr,
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20.w, right: 20.w, left: 20.w),
                    child: Column(
                      children: [
                        TextFormField(
                          maxLines: 4,
                          controller: articleCtr,
                          autofocus: false,
                          cursorColor: AppColors.primaryColor,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.white,
                              contentPadding:  EdgeInsets.all(10.w),
                              prefixIcon: Padding(
                                padding:  EdgeInsets.all(10.0.w),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Write your article ( in markdown )"),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20.w, right: 20.w, left: 20.w),
                    child: Column(
                      children: [
                        TextFormField(
                          autofocus: false,
                          controller: tagsCtr,
                          cursorColor: AppColors.primaryColor,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.white,
                              contentPadding: EdgeInsets.all(10.w),
                              prefixIcon: Padding(
                                padding:  EdgeInsets.all(10.0.w),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3.w, color: AppColors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Enter tags"
                              //prefixText: 'GJ011685',
                              ),
                          // controller: emailCtr,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25.w, left: 60.w, right: 60.w),
                    child: SizedBox(
                      height: 40.h,
                      child: MaterialButton(
                        color: AppColors.primaryColor,
                        // disabledColor: AppColors.Bottom_bar_color,
                        minWidth: MediaQuery.of(context).size.width,
                        textColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          // side: BorderSide(color: AppColors.primaryColor),
                        ),
                        onPressed: () {
                          FocusManager.instance.primaryFocus!.unfocus();

                          if (_form.currentState!.validate()) {
                            articleBloc.add(
                              SubmitArticleEvent(
                                articleModel: ArticleModel(
                                  article: Article(
                                    title: titleCtr!.text.trim(),
                                    description: aboutTitleCtr!.text.trim(),
                                    body: articleCtr!.text.trim(),
                                    // tagList: tagsCtr!.text.trim(),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            CToast.instance
                                .showError(context, "New article not added");
                          }
                        },
                        child: isLoading
                            ? Container(
                                height: 40.h,
                                padding: EdgeInsets.all(8.w),
                                child: CToast.instance.showLoader(),
                              )
                            : Text(
                                'Publish Article',
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
