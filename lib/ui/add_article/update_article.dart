// import 'package:conduit/bloc/article_bloc/article_bloc.dart';
// import 'package:conduit/bloc/article_bloc/article_event.dart';
// import 'package:conduit/bloc/article_bloc/article_state.dart';
// import 'package:conduit/config/constant.dart';
// import 'package:conduit/main.dart';
// import 'package:conduit/model/new_article_model.dart';
// import 'package:conduit/ui/base/home_screen.dart';
// import 'package:conduit/utils/AppColors.dart';
// import 'package:conduit/utils/functions.dart';
// import 'package:conduit/utils/image_string.dart';
// import 'package:conduit/utils/message.dart';
// import 'package:conduit/widget/conduitEditText_widget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';

// class UpdateArticleScreen extends StatefulWidget {
//   UpdateArticleScreen({Key? key, required this.slug}) : super(key: key);
//   String slug;


//   @override
//   State<UpdateArticleScreen> createState() => _UpdateArticleScreenState();
// }

// class _UpdateArticleScreenState extends State<UpdateArticleScreen> {
//   GlobalKey<FormState> _form = GlobalKey<FormState>();
//   TextEditingController? titleCtr, aboutTitleCtr, articleCtr, tagsCtr;
//   late ArticleBloc articleBloc;
//   String? title, aboutTitle, article;
//   String? apiSlug;
//   List<String> tags = [];

//   // List<ArticleModel>? articleModel;
//   // bool isLoading = false;
//   @override
//   void initState() {
//     super.initState();
//     articleBloc = context.read<ArticleBloc>();
//     articleBloc.add(FetchArticleEvent(slug: widget.slug));
//     addData();
//   }

//   void addData() {
//     titleCtr = TextEditingController(text: title);
//     aboutTitleCtr = TextEditingController(text: aboutTitle);
//     articleCtr = TextEditingController(text: article);
//     tagsCtr = TextEditingController(
//         text: tags.toString().substring(1, tags.toString().length - 1));
//   }

//   void clear() {
//     setState(() {
//       titleCtr!.clear();
//       aboutTitleCtr!.clear();
//       articleCtr!.clear();
//       tagsCtr!.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: WillPopScope(
//         onWillPop: () async => true,
//         child: Scaffold(
//           backgroundColor: AppColors.white,
//           appBar: AppBar(
//             backgroundColor: AppColors.primaryColor,
//             centerTitle: true,
//             automaticallyImplyLeading: false,
//             leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: SvgPicture.asset(
//                 ic_back_arrow_icon,
//                 color: AppColors.white,
//               ),
//             ),
//             title: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   "Update Article",
//                   style: TextStyle(
//                     color: AppColors.white,
//                     fontSize: 18,
//                     fontFamily: ConduitFontFamily.robotoRegular,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           body: SafeArea(
//               child: BlocConsumer<ArticleBloc, ArticleState>(
//             listener: (context, state) {
//               // TODO: implement listener
//               if (state is ArticleLoadingState) {
//                 return CToast.instance.showLoaderDialog(context);
//               }
//               if (state is ArticleNoInternetState) {
//                 Navigator.pop(context);
//                 CToast.instance.showError(context, NO_INTERNET);
//               }

//               if (state is UpdateArticleSuccessState) {
//                 Navigator.pop(context);
//                 Future.delayed(Duration(seconds: 2), () {
//                   Navigator.popUntil(context, (route) => route.isFirst);
//                   Navigator.pushReplacement(
//                       context,
//                       CupertinoPageRoute(
//                         builder: (context) => BaseScreen(),
//                       ));
//                 });
//               }
//               if (state is ArticleLoadedState) {
//                 title = state.articleModel.last.article?.title;
//                 aboutTitle = state.articleModel.last.article?.description;
//                 article = state.articleModel.last.article?.body;
//                 apiSlug = state.articleModel.last.article!.slug;
//                 tags = state.articleModel.last.article!.tagList!;
//                 addData();
//                 Navigator.pop(context);
//               }
//               if (state is ArticleErrorState) {
//                 Navigator.pop(context);
//                 Future.delayed(Duration.zero, () {
//                   CToast.instance.showError(context, state.msg);
//                 });
//               }
//             },
//             builder: (context, state) {
//               return ScrollConfiguration(
//                 behavior: NoGlow(),
//                 child: SingleChildScrollView(
//                   child: Form(
//                     key: _form,
//                     child: Column(
//                       children: [
//                         Container(
//                           padding:
//                               EdgeInsets.only(top: 50, right: 20, left: 20),
//                           child: Column(
//                             children: [
//                               ConduitEditText(
//                                 controller: titleCtr,
//                                 maxLines: 1,
//                                 hint: "Article title",
//                                 textInputType: TextInputType.text,
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               ConduitEditText(
//                                 controller: aboutTitleCtr,
//                                 hint: "About?",
//                                 maxLines: 2,
//                                 minLines: 1,
//                                 textInputType: TextInputType.text,
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               ConduitEditText(
//                                 maxLines: 8,
//                                 minLines: 5,
//                                 controller: articleCtr,
//                                 hint: "Your article ( in markdown )",
//                                 textInputType: TextInputType.text,
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               ConduitEditText(
//                                 controller: tagsCtr,
//                                 hint: "Tags",
//                                 maxLines: 2,
//                                 minLines: 1,
//                                 textInputType: TextInputType.text,
//                                 inputFormatters: [
//                                   FilteringTextInputFormatter.deny(" "),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width,
//                                 child: CupertinoButton(
//                                   color: AppColors.primaryColor,
//                                   disabledColor: AppColors.Bottom_bar_color,
//                                   borderRadius: BorderRadius.circular(10),
//                                   onPressed: () {
//                                     FocusManager.instance.primaryFocus!
//                                         .unfocus();
//                                     if (_form.currentState!.validate()) {
//                                       tags = tagsCtr!.text.split(',');
//                                       articleBloc.add(
//                                         UpdateArticleEvent(
//                                             articleModel: ArticleModel(
//                                               article: Article(
//                                                 title: titleCtr!.text.trim(),
//                                                 description:
//                                                     aboutTitleCtr!.text.trim(),
//                                                 body: articleCtr!.text.trim(),
//                                                 tagList: tags,
//                                               ),
//                                             ),
//                                             slug: apiSlug!),
//                                       );
//                                     } else {
//                                       CToast.instance.showError(
//                                           context, "article not updated");
//                                     }
//                                   },
//                                   child: Text(
//                                     'Update Article',
//                                     style: TextStyle(
//                                       color: AppColors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily:
//                                           ConduitFontFamily.robotoRegular,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 20)
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           )),
//         ),
//       ),
//     );
//   }
// }