import 'package:conduit/bloc/new_article_bloc/new_article_bloc.dart';
import 'package:conduit/bloc/new_article_bloc/new_article_event.dart';
import 'package:conduit/bloc/new_article_bloc/new_article_state.dart';
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
  TextEditingController? titleCtr;
  TextEditingController? aboutTitleCtr;
  TextEditingController? articleCtr;
  TextEditingController? tagsCtr;
  late NewArticleBloc articleBloc;
  // List<ArticleModel>? articleModel;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    articleBloc = context.read<NewArticleBloc>();
    articleBloc.add(FetchArticle(slug: widget.slug));

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
    return Scaffold(
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
        child: BlocBuilder<NewArticleBloc, NewArticleState>(
          builder: (context, state) {
            if (state is FetchArticleLoadingState) {
              return Center(child: CToast.instance.showLoader());
            }

            if (state is UpdateArticleSuccessState) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
              clear();
              CToast.instance.showSuccess(context, "Article updated");
            }

            if (state is FetchArticleErroeState) {
              CToast.instance.showError(context, state.msg);
            }
            if (state is FetchArticleSuccessState) {
              Form(
                key: _form,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                      child: Column(
                        children: [
                          TextFormField(
                            autofocus: false,
                            // initialValue:
                            //     state.articleModel.last.article?.title ??
                            //         "--".toString(),
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
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
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
                      padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                      child: Column(
                        children: [
                          TextFormField(
                            autofocus: false,
                            // initialValue: state.articleModel.last.article
                            //         ?.description ??
                            //     "--",
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
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
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
                      padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                      child: Column(
                        children: [
                          TextFormField(
                            maxLines: 4,
                            controller: articleCtr,
                            // initialValue:
                            //     state.articleModel.last.article?.body ??
                            //         "--",
                            autofocus: false,
                            cursorColor: AppColors.primaryColor,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.white,
                                contentPadding: const EdgeInsets.all(10),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
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
                                hintText: "Write your article ( in markdown )"),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                      child: Column(
                        children: [
                          TextFormField(
                            autofocus: false,
                            controller: tagsCtr,
                            // initialValue: state.articleModel.last.article!.tagList as List<String>,
                            cursorColor: AppColors.primaryColor,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.white,
                                contentPadding: const EdgeInsets.all(10),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
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
                                hintText: "Enter tags"
                                //prefixText: 'GJ011685',
                                ),
                            // controller: emailCtr,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25, left: 60, right: 60),
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
                              articleBloc.add(
                                UpdateArticle(
                                    newArticleModel: ArticleModel(
                                      article: Article(
                                        title: titleCtr!.text.trim(),
                                        description: aboutTitleCtr!.text.trim(),
                                        body: articleCtr!.text.trim(),
                                        // tagList: tagsCtr!.text.trim(),
                                      ),
                                    ),
                                    slug:
                                        state.articleModel.last.article!.slug!),
                              );
                            } else {
                              CToast.instance
                                  .showError(context, "article not updated");
                            }
                          },
                          child: isLoading
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
                  ],
                ),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
