import 'package:conduit/bloc/article_bloc/article_bloc.dart';
import 'package:conduit/bloc/article_bloc/article_event.dart';
import 'package:conduit/bloc/article_bloc/article_state.dart';
import 'package:conduit/main.dart';
import 'package:conduit/model/new_article_model.dart';
import 'package:conduit/ui/home/home_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/conduitEditText_widget.dart';
import 'package:conduit/widget/theme_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  List<String>? tags;
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
      child: WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          backgroundColor: AppColors.white2,
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            centerTitle: false,
            leading: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
                child: Icon(Icons.arrow_back)),
            title: Text(
              "Add Article",
              style: TextStyle(
                color: AppColors.white,
                fontFamily: ConduitFontFamily.robotoRegular,
              ),
            ),
          ),
          body: ThemeContainer(
            child: WillPopScope(
              onWillPop: () async => true,
              child: SingleChildScrollView(
                child: SafeArea(
                  child: BlocListener<ArticleBloc, ArticleState>(
                    listener: (context, state) {
                      if (state is ArticleLoadingState) {
                        setState(() {
                          isLoading = true;
                        });
                        CToast.instance.showLoaderDialog(context);
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        // CToast.instance.dismiss();
                      }

                      if (state is ArticleAddSuccessState) {
                        clear();
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => HomeScreen()));
                        CToast.instance
                            .showSuccess(context, state.msg.toString());
                      }

                      if (state is ArticleAddErrorState) {
                        // this pop for showLoaderDialog dismiss
                        Navigator.pop(context);
                        CToast.instance
                            .showError(context, state.msg.toString());
                      }
                    },
                    child: Form(
                      key: _form,
                      child: Column(children: [
                        Container(
                          padding:
                              EdgeInsets.only(top: 20, right: 20, left: 20),
                          child: Column(
                            children: [
                              ConduitEditText(
                                controller: titleCtr,
                                maxLines: 1,
                                hint: "Article title",
                                textInputType: TextInputType.text,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(150),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter a title';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ConduitEditText(
                                controller: aboutTitleCtr,
                                hint: "About?",
                                maxLines: 2,
                                minLines: 1,
                                textInputType: TextInputType.text,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(150)
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter article's about";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ConduitEditText(
                                maxLines: 8,
                                minLines: 5,
                                controller: articleCtr,
                                hint: "Your article ( in markdown )",
                                textInputType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter article';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ConduitEditText(
                                controller: tagsCtr,
                                hint: "Tags",
                                maxLines: 1,
                                textInputType: TextInputType.text,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                // height: 40,
                                width: MediaQuery.of(context).size.width,
                                child: CupertinoButton(
                                  color: AppColors.primaryColor,
                                  disabledColor: AppColors.text_color,
                                  borderRadius: BorderRadius.circular(10),
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus!
                                        .unfocus();
                                    if (_form.currentState!.validate()) {
                                      tags = tagsCtr!.text.split(',');
                                      print(tags);
                                      articleBloc.add(
                                        SubmitArticleEvent(
                                          articleModel: ArticleModel(
                                            article: Article(
                                              title: titleCtr!.text.trim(),
                                              description:
                                                  aboutTitleCtr!.text.trim(),
                                              body: articleCtr!.text.trim(),
                                              tagList: tags,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Publish Article',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          ConduitFontFamily.robotoRegular,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
