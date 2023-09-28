import 'package:conduit/bloc/article_bloc/article_bloc.dart';
import 'package:conduit/bloc/article_bloc/article_event.dart';
import 'package:conduit/bloc/article_bloc/article_state.dart';
import 'package:conduit/config/constant.dart';
import 'package:conduit/main.dart';
import 'package:conduit/model/new_article_model.dart';
import 'package:conduit/navigator/tab_items.dart';
import 'package:conduit/ui/base/base_screen.dart';
import 'package:conduit/ui/global/global_item_detail_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/functions.dart';
import 'package:conduit/utils/image_string.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/conduitEditText_widget.dart';
import 'package:conduit/utils/theme_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class AddArticleScreen extends StatefulWidget {
  static const addArticleUrl = '/addArticle';
  AddArticleScreen({
    Key? key,
    required this.isUpdateArticle,
    this.slug,
  }) : super(key: key);
  bool isUpdateArticle;
  String? slug;

  @override
  State<AddArticleScreen> createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();

  bool isVisible = false;
  // String? title, aboutTitle, article;
  // String? apiSlug;
  TextEditingController? titleCtr, aboutTitleCtr, articleCtr;
  TextEditingController? tagsCtr;
  late ArticleBloc articleBloc;
  List<String> tags = [];
  ArticleModel? articleModel;
  bool isEdited = false;

  bool isNoInternet = false;
  @override
  void initState() {
    super.initState();

    articleBloc = context.read<ArticleBloc>();

    if (widget.isUpdateArticle) {
      articleBloc.add(FetchArticleEvent(slug: widget.slug!));
      addData();
    } else {
      titleCtr = TextEditingController();
      aboutTitleCtr = TextEditingController();
      articleCtr = TextEditingController();
    }
    tagsCtr = TextEditingController();
  }

  void addData() {
    titleCtr = TextEditingController(text: articleModel?.article?.title);
    aboutTitleCtr =
        TextEditingController(text: articleModel?.article?.description);
    articleCtr = TextEditingController(text: articleModel?.article?.body);
  }

  void clear() {
    setState(() {
      titleCtr!.clear();
      aboutTitleCtr!.clear();
      articleCtr!.clear();
      tagsCtr!.clear();
    });
  }

  void addTag(String tag) {
    print(tag);
    setState(() {
      tags.add(tag);
      tagsCtr?.clear();
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
            leading: IconButton(
              onPressed: () async {
                if (widget.isUpdateArticle) {
                  Navigator.pop(context, isEdited ? true : false);
                } else {
                  bool isPop =
                      await navigatorKey[BaseScreen.getCurrentTab(context)]!
                          .currentState!
                          .maybePop();
                  if (!isPop) {
                    BaseScreen.switchTab(context, MyTabItem.globalfeed);
                  }
                }
              },
              icon: SvgPicture.asset(
                ic_back_arrow_icon,
                color: AppColors.white,
              ),
            ),
            title: Text(
              widget.isUpdateArticle ? "Update Article" : "Add Article",
              style: TextStyle(
                color: AppColors.white,
                fontFamily: ConduitFontFamily.robotoRegular,
              ),
            ),
          ),
          body: ThemeContainer(
            child: WillPopScope(
              onWillPop: () async => true,
              child: ScrollConfiguration(
                behavior: NoGlow(),
                child: SingleChildScrollView(
                  child: SafeArea(
                      child: BlocConsumer<ArticleBloc, ArticleState>(
                    listener: (context, state) {
                      if (state is ArticleLoadingState) {
                        CToast.instance.showLodingLoader(context);
                      }
                      if (state is ArticleNoInternetState) {
                        CToast.instance.dismiss();
                        CToast.instance.showError(context, NO_INTERNET);
                      }
                      // add article
                      if (state is ArticleAddSuccessState) {
                        clear();
                        CToast.instance.dismiss();
                        BaseScreen.switchTab(context, MyTabItem.globalfeed);
                        CToast.instance
                            .showSuccess(context, state.msg.toString());
                      }
                      if (state is ArticleAddErrorState) {
                        CToast.instance.dismiss();
                        CToast.instance
                            .showError(context, state.msg.toString());
                      }

                      // update article
                      if (state is UpdateArticleSuccessState) {
                        CToast.instance.dismiss();
                        Navigator.pop(context, isEdited ? true : false);
                        // Navigator.popUntil(context, (route) => route.isFirst);
                        // Navigator.pushNamed(
                        //   context,
                        //   GlobalItemDetailScreen.globalItemDetailUrl,
                        //   arguments: {
                        //     'username': articleModel!.article!.author!.username,
                        //     'slug': articleModel!.article!.slug,
                        //   },
                        // );
                      }
                      if (state is ArticleLoadedState) {
                        articleModel = state.articleModel.last;
                        // title = state.articleModel.last.article?.title;
                        // aboutTitle =
                        //     state.articleModel.last.article?.description;
                        // article = state.articleModel.last.article?.body;
                        // apiSlug = state.articleModel.last.article!.slug;
                        tags = state.articleModel.last.article!.tagList!;
                        addData();
                        CToast.instance.dismiss();
                      }
                    },
                    builder: (context, state) {
                      return Form(
                        key: _form,
                        child: Container(
                          padding:
                              EdgeInsets.only(top: 20, right: 20, left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Title*",
                                style: TextStyle(
                                  fontFamily: ConduitFontFamily.robotoLight,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
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
                              Text(
                                "About*",
                                style: TextStyle(
                                  fontFamily: ConduitFontFamily.robotoLight,
                                ),
                              ),
                              SizedBox(
                                height: 10,
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
                              Text(
                                "Your article*",
                                style: TextStyle(
                                  fontFamily: ConduitFontFamily.robotoLight,
                                ),
                              ),
                              SizedBox(
                                height: 10,
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
                              Visibility(
                                visible: isVisible,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.white,
                                      border: Border.all(
                                          color: AppColors.primaryColor),
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "1. Start typing the tag you want to create.\n\n"
                                    "2. After typing the tag, press the 'Done' or 'Next' button on your keyboard.\n\n"
                                    "3. The tag you typed will automatically be converted into a tag and added to the list of tags below the input field.\n\n"
                                    "4. You can continue typing and creating more tags using the same method.",
                                    style: TextStyle(
                                        fontFamily:
                                            ConduitFontFamily.robotoLight),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Tags',
                                style: TextStyle(
                                  fontFamily: ConduitFontFamily.robotoLight,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ConduitEditText(
                                controller: tagsCtr,
                                hint: "Tags",
                                maxLines: 2,
                                minLines: 1,
                                textInputType: TextInputType.text,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(" "),
                                  FilteringTextInputFormatter.allow(
                                    RegExp("[0-9a-z]"),
                                  ),
                                ],
                                onEditingComplete: () {
                                  final text = tagsCtr!.text.trim();
                                  if (text.isNotEmpty) {
                                    addTag(text);
                                    tagsCtr!.clear();
                                    print(tags);
                                  }
                                },
                                validator: (value) {
                                  if (value!.isEmpty && tags.isEmpty) {
                                    return "Write at least one tag";
                                  }
                                  return null;
                                },
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                  child: Transform.scale(
                                    scale: 0.9,
                                    child: isVisible
                                        ? Icon(
                                            Icons.close,
                                            color: AppColors.pholder_background,
                                          )
                                        : Icon(
                                            Icons.info_outline,
                                            color: AppColors.pholder_background,
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Wrap(
                                children: tags.map((tag) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Chip(
                                      label: Text(tag),
                                      onDeleted: () {
                                        setState(() {
                                          tags.remove(tag);
                                        });
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: CupertinoButton(
                                  color: AppColors.primaryColor,
                                  disabledColor: AppColors.text_color,
                                  borderRadius: BorderRadius.circular(10),
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus!
                                        .unfocus();
                                    if (_form.currentState!.validate()) {
                                      print(tags);
                                      if (widget.isUpdateArticle) {
                                        setState(() {
                                          isEdited = true;
                                        });
                                        articleBloc.add(
                                          UpdateArticleEvent(
                                              articleModel: ArticleModel(
                                                article: Article(
                                                  title: titleCtr!.text.trim(),
                                                  description: aboutTitleCtr!
                                                      .text
                                                      .trim(),
                                                  body: articleCtr!.text.trim(),
                                                  tagList: tags,
                                                ),
                                              ),
                                              slug:
                                                  articleModel!.article!.slug!),
                                        );
                                      } else {
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
                                    }
                                  },
                                  child: Text(
                                    widget.isUpdateArticle
                                        ? "Update"
                                        : 'Publish Article',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          ConduitFontFamily.robotoRegular,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
