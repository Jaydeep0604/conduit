// import 'package:conduit/bloc/add_comment_bloc/add_comment_bloc.dart';
// import 'package:conduit/bloc/add_comment_bloc/add_comment_event.dart';
// import 'package:conduit/bloc/add_comment_bloc/add_comment_state.dart';
// import 'package:conduit/bloc/comment_bloc/comment_bloc.dart';
// import 'package:conduit/bloc/comment_bloc/comment_event.dart';
// import 'package:conduit/bloc/comment_bloc/comment_state.dart';
// import 'package:conduit/model/all_artist_model.dart';
// import 'package:conduit/model/comment_model.dart';
// import 'package:conduit/utils/AppColors.dart';
// import 'package:conduit/utils/message.dart';
// import 'package:conduit/widget/comment_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CommentViewScreen extends StatefulWidget {
//   CommentViewScreen({Key? key,this.allArticlesModel}) : super(key: key);
//   AllArticlesModel? allArticlesModel;
//   @override
//   State<CommentViewScreen> createState() => _CommentViewScreenState();
// }

// class _CommentViewScreenState extends State<CommentViewScreen> {
//   bool isLoading = false;
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   late AddCommentBloc addCommentBloc;
//   TextEditingController? commentCtr;

//   late CommentBloc commentBloc;
//   void initState() {
//     commentCtr = TextEditingController();
//     addCommentBloc = context.read<AddCommentBloc>();

//     commentBloc = context.read<CommentBloc>();
//     commentBloc.add(fetchCommentEvent());
//   }

//   void refreshComments() {
//     commentBloc.add(fetchCommentEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         BlocListener<AddCommentBloc, AddCommentState>(
//           listener: (context, state) {
//             if (state is AddCommentLoadingState) {
//               setState(() {
//                 isLoading = true;
//               });
//             }
//             if (state is AddCommentErroeState) {
//               isLoading = false;
//               // CToast.instance.showError(context, state.msg);
//             }
//             if (state is AddCommentSuccessState) {
//               commentCtr!.clear();
//               setState(() {
//                 isLoading = false;
//               });
//               refreshComments();
//             }
//           },
//           child: Padding(
//             padding: const EdgeInsets.only(left: 15, right: 15),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 border: Border.all(
//                   color: AppColors.black.withOpacity(0.5),
//                 ),
//               ),
//               child: Form(
//                 key: formKey,
//                 autovalidateMode: AutovalidateMode.always,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       maxLines: 3,
//                       controller: commentCtr,
//                       cursorColor: AppColors.primaryColor,
//                       keyboardType: TextInputType.text,
//                       style: TextStyle(
//                         color: Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         hintText: "Write a comment...",
//                         filled: true,
//                         enabled: true,
//                         fillColor: AppColors.white2,
//                         contentPadding: const EdgeInsets.all(10),
//                         prefixIcon: Padding(
//                           padding: const EdgeInsets.all(15.0),
//                         ),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                         disabledBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 3, color: AppColors.white2),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 3, color: AppColors.white2),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 3, color: AppColors.white2),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 3, color: AppColors.white2),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         focusedErrorBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(width: 3, color: AppColors.white2),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                     Divider(
//                       color: AppColors.black.withOpacity(0.5),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 3, horizontal: 8),
//                         child: Row(
//                           children: [
//                             CircleAvatar(
//                               radius: 15,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(50),
//                                 child: Image.network(
//                                     "${widget.allArticlesModel?.author?.image}"),
//                               ),
//                             ),
//                             Spacer(),
//                             Container(
//                               height: 30,
//                               width: 120,
//                               decoration: BoxDecoration(
//                                 color: commentCtr!.text.isNotEmpty
//                                     ? AppColors.primaryColor
//                                     : AppColors.button_color,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: TextButton(
//                                 onPressed: () {
//                                   FocusManager.instance.primaryFocus?.unfocus();
//                                   if (formKey.currentState!.validate()) {
//                                     addCommentBloc.add(
//                                       SubmitCommentEvent(
//                                         addCommentModel: AddCommentModel(
//                                           comment: Comment(
//                                             body: commentCtr!.text.toString(),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 child: isLoading
//                                     ? CToast.instance.showLoader()
//                                     : Text(
//                                         "Post Comment",
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           color: AppColors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         BlocBuilder<CommentBloc, CommentState>(
//           builder: (context, state) {
//             if (state is CommentErrorState) {
//               return CToast.instance.showError(context, state.msg);
//             }
//             if (state is CommentLoadingState) {
//               Center(child: CToast.instance.showLoader());
//             }
//             if (state is NoCommentState) {
//               return SizedBox();
//             }
//             if (state is CommentSuccessState) {
//               return Padding(
//                 padding: const EdgeInsets.only(
//                     left: 15, right: 15, top: 10, bottom: 10),
//                 child: ListView.separated(
//                   primary: false,
//                   shrinkWrap: true,
//                   scrollDirection: Axis.vertical,
//                   itemCount: state.commentModel.length,
//                   itemBuilder: (context, index) {
//                     return CommentWidget(
//                       commentModel: state.commentModel[index],
//                     );
//                   },
//                   separatorBuilder: (BuildContext context, int index) {
//                     return SizedBox(
//                       height: 10,
//                     );
//                   },
//                 ),
//               );
//             }
//             return SizedBox();
//           },
//         ),
//       ],
//     );
//   }
// }


// // class AddCommentScreen extends StatefulWidget {
// //   AddCommentScreen({Key? key, this.allArticlesModel}) : super(key: key);
// //   AllArticlesModel? allArticlesModel;
// //   @override
// //   State<AddCommentScreen> createState() => _AddCommentScreenState();
// // }
// // class _AddCommentScreenState extends State<AddCommentScreen> {
// //   bool isLoading = false;
// //   GlobalKey<FormState> formKey = GlobalKey<FormState>();
// //   late AddCommentBloc addCommentBloc;
// //   TextEditingController? commentCtr;
// //   void initState() {
// //     super.initState();
// //     commentCtr = TextEditingController();
// //     addCommentBloc = context.read<AddCommentBloc>();
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocListener<AddCommentBloc, AddCommentState>(
// //       listener: (context, state) {
// //         if (state is AddCommentLoadingState) {
// //           setState(() {
// //             isLoading = true;
// //           });
// //         }
// //         if (state is AddCommentErroeState) {
// //           isLoading = false;
// //           // CToast.instance.showError(context, state.msg);
// //         }
// //         if (state is AddCommentSuccessState) {
// //           commentCtr!.clear();
// //           setState(() {
// //             isLoading = false;
// //           });
// //           // commentViewScreen.refreshComments();
// //         }
// //       },
// //       child: Padding(
// //         padding: const EdgeInsets.only(left: 15, right: 15),
// //         child: Container(
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(5),
// //             border: Border.all(
// //               color: AppColors.black.withOpacity(0.5),
// //             ),
// //           ),
// //           child: Form(
// //             key: formKey,
// //             autovalidateMode: AutovalidateMode.always,
// //             child: Column(
// //               children: [
// //                 TextFormField(
// //                   maxLines: 3,
// //                   controller: commentCtr,
// //                   cursorColor: AppColors.primaryColor,
// //                   keyboardType: TextInputType.text,
// //                   style: TextStyle(
// //                     color: Colors.black,
// //                   ),
// //                   decoration: InputDecoration(
// //                     hintText: "Write a comment...",
// //                     filled: true,
// //                     enabled: true,
// //                     fillColor: AppColors.white2,
// //                     contentPadding: const EdgeInsets.all(10),
// //                     prefixIcon: Padding(
// //                       padding: const EdgeInsets.all(15.0),
// //                     ),
// //                     border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(10)),
// //                     disabledBorder: OutlineInputBorder(
// //                       borderSide: BorderSide(width: 3, color: AppColors.white2),
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     focusedBorder: OutlineInputBorder(
// //                       borderSide: BorderSide(width: 3, color: AppColors.white2),
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     enabledBorder: OutlineInputBorder(
// //                       borderSide: BorderSide(width: 3, color: AppColors.white2),
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     errorBorder: OutlineInputBorder(
// //                       borderSide: BorderSide(width: 3, color: AppColors.white2),
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     focusedErrorBorder: OutlineInputBorder(
// //                       borderSide: BorderSide(width: 3, color: AppColors.white2),
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                   ),
// //                 ),
// //                 Divider(
// //                   color: AppColors.black.withOpacity(0.5),
// //                 ),
// //                 Container(
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(5),
// //                   ),
// //                   child: Padding(
// //                     padding:
// //                         const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
// //                     child: Row(
// //                       children: [
// //                         CircleAvatar(
// //                           radius: 15,
// //                           child: ClipRRect(
// //                             borderRadius: BorderRadius.circular(50),
// //                             child: Image.network(
// //                                 "${widget.allArticlesModel?.author?.image}"),
// //                           ),
// //                         ),
// //                         Spacer(),
// //                         Container(
// //                           height: 30,
// //                           width: 120,
// //                           decoration: BoxDecoration(
// //                             color: commentCtr!.text.isNotEmpty
// //                                 ? AppColors.primaryColor
// //                                 : AppColors.button_color,
// //                             borderRadius: BorderRadius.circular(5),
// //                           ),
// //                           child: TextButton(
// //                             onPressed: () {
// //                               if (formKey.currentState!.validate()) {
// //                                 addCommentBloc.add(
// //                                   SubmitCommentEvent(
// //                                     addCommentModel: AddCommentModel(
// //                                       comment: Comment(
// //                                         body: commentCtr!.text.toString(),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 );
// //                               }
// //                             },
// //                             child: isLoading
// //                                 ? CToast.instance.showLoader()
// //                                 : Text(
// //                                     "Post Comment",
// //                                     textAlign: TextAlign.center,
// //                                     style: TextStyle(
// //                                       color: AppColors.white,
// //                                       fontWeight: FontWeight.bold,
// //                                     ),
// //                                   ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: 5),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
