import 'package:conduit/bloc/article_bloc/article_bloc.dart';
import 'package:conduit/bloc/article_bloc/article_event.dart';
import 'package:conduit/bloc/article_bloc/article_state.dart';
import 'package:conduit/model/new_article_model.dart';
import 'package:conduit/ui/home/home_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateArticleScreen extends StatefulWidget {
  UpdateArticleScreen({Key? key, required this.slug}) : super(key: key);
  String slug;

  @override
  State<UpdateArticleScreen> createState() => _UpdateArticleScreenState();
}

class _UpdateArticleScreenState extends State<UpdateArticleScreen> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController? titleCtr, aboutTitleCtr, articleCtr, tagsCtr;
  late ArticleBloc articleBloc;
  String? title, aboutTitle, article;
  List<String>? tagsList;
  // List<ArticleModel>? articleModel;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    articleBloc = context.read<ArticleBloc>();
    articleBloc.add(FetchArticleEvent(slug: widget.slug));
    addData();
  }

  void addData() {
    titleCtr = TextEditingController(text: title);
    aboutTitleCtr = TextEditingController(text: aboutTitle);
    articleCtr = TextEditingController(text: article);
    // tagsCtr = TextEditingController(text:  tagsList );
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
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.white2,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Update Article",
                style: TextStyle(color: AppColors.white, fontSize: 18),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<ArticleBloc, ArticleState>(
            builder: (context, state) {
              if (state is ArticleLoadingState) {
                return Center(child: CToast.instance.showLoader());
              }
              if (state is UpdateArticleLoadingState) {
                return Center(child: CToast.instance.showLoader());
              }
              if (state is UpdateArticleSuccessState) {
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                });
              }
              if (state is ArticleErrorState) {
                Future.delayed(Duration.zero, () {
                  CToast.instance.showError(context, state.msg);
                });
              }
              if (state is ArticleLoadedState) {
                title = state.articleModel.last.article?.title;
                aboutTitle = state.articleModel.last.article?.description;
                article = state.articleModel.last.article?.body;
                // tagsList = state.articleModel.last.article?.tagList as String;
                addData();
                return SingleChildScrollView(
                  child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(top: 20, right: 20, left: 20),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: titleCtr,
                                cursorColor: AppColors.primaryColor,
                                keyboardType: TextInputType.text,

                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.white,
                                    contentPadding: const EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: "Article Title"),
                                // controller: emailCtr,
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(top: 20, right: 20, left: 20),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: aboutTitleCtr,
                                cursorColor: AppColors.primaryColor,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.white,
                                    contentPadding: const EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: "What's this article about?"),
                                // controller: emailCtr,
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(top: 20, right: 20, left: 20),
                          child: Column(
                            children: [
                              TextFormField(
                                maxLines: 4,
                                controller: articleCtr,
                                cursorColor: AppColors.primaryColor,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.white,
                                    contentPadding: const EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText:
                                        "Write your article ( in markdown )"),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(top: 20, right: 20, left: 20),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: tagsCtr,
                                cursorColor: AppColors.primaryColor,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.white,
                                    contentPadding: const EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3, color: AppColors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    ),
                                // controller: emailCtr,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 25, left: 60, right: 60),
                          child: SizedBox(
                            height: 40,
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
                                  setState(() {
                                    isLoading = true;
                                  });
                                  articleBloc.add(
                                    UpdateArticleEvent(
                                        articleModel: ArticleModel(
                                          article: Article(
                                            title: titleCtr!.text.trim(),
                                            description:
                                                aboutTitleCtr!.text.trim(),
                                            body: articleCtr!.text.trim(),
                                            // tagList: tagsCtr!.text.trim(),
                                          ),
                                        ),
                                        slug: state
                                            .articleModel.last.article!.slug!),
                                  );
                                } else {
                                  CToast.instance.showError(
                                      context, "article not updated");
                                }
                              },
                              child: isLoading == true
                                  ? Container(
                                      height: 40,
                                      padding: EdgeInsets.all(8),
                                      child: CToast.instance.showLoader(),
                                    )
                                  : Text(
                                      'Update Article',
                                      style: TextStyle(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20)
                      ],
                    ),
                  ),
                );
              }
              return isLoading
                  ? Center(
                      child: CToast.instance.showLoader(),
                    )
                  : Center(
                      child:
                          Text("Something want wrong plesee try again later."),
                    );
            },
          ),
        ),
      ),
    );
  }
}
