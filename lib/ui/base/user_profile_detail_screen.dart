// // import 'package:conduit/main.dart';
// // import 'package:conduit/model/all_article_model.dart';
// // import 'package:conduit/utils/AppColors.dart';
// // import 'package:flutter/material.dart';

// // class UserProfileDetailScreen extends StatefulWidget {
// //   UserProfileDetailScreen({Key? key, required this.allArticlesModel})
// //       : super(key: key);
// //   AllArticlesModel allArticlesModel;

// //   @override
// //   State<UserProfileDetailScreen> createState() =>
// //       _UserProfileDetailScreenState();
// // }

// // class _UserProfileDetailScreenState extends State<UserProfileDetailScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return WillPopScope(
// //       onWillPop: () async => true,
// //       child: Scaffold(
// //         backgroundColor: AppColors.white2,
// //         appBar: AppBar(
// //           backgroundColor: AppColors.primaryColor,
// //           // centerTitle: true,
// //           automaticallyImplyLeading: false,
// //           leading: IconButton(
// //               onPressed: () {
// //                 Navigator.pop(context);
// //               },
// //               icon: Icon(Icons.arrow_back)),
// //           title: Text(
// //             "Profile",
// //             style: TextStyle(
// //               color: AppColors.white,
// //               fontSize: 20,
// //               fontFamily: ConduitFontFamily.robotoRegular,
// //             ),
// //           ),
// //         ),
// //         body: SafeArea(
// //             child: Padding(
// //           padding: const EdgeInsets.all(10),
// //           child: Column(
// //             // mainAxisAlignment: MainAxisAlignment.start,
// //             // crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               SizedBox(height: 20.0),
// //               Container(
// //                 decoration: BoxDecoration(
// //                     color: AppColors.white,
// //                     border: Border.all(color: AppColors.black.withOpacity(0.4)),
// //                     borderRadius: BorderRadius.circular(20)),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.start,
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         // mainAxisAlignment: MainAxisAlignment.center,
// //                         // crossAxisAlignment: CrossAxisAlignment.center,
// //                         children: [
// //                           Container(
// //                             height: 80,
// //                             width: 80,
// //                             decoration: BoxDecoration(
// //                               border: Border.all(color: AppColors.black),
// //                               borderRadius: BorderRadius.circular(50),
// //                             ),
// //                             child: ClipRRect(
// //                               borderRadius: BorderRadius.circular(50),
// //                               child: Image.network(
// //                                 "${widget.allArticlesModel.author!.image}",
// //                                 fit: BoxFit.fill,
// //                               ),
// //                             ),
// //                           ),
// //                           SizedBox(width: 16.0),
// //                           Text(
// //                             '${widget.allArticlesModel.author!.username}',
// //                             style: TextStyle(
// //                               fontSize: 16.0,
// //                               color: AppColors.black,
// //                               fontFamily: ConduitFontFamily.robotoRegular,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       SizedBox(height: 16.0),
// //                       Container(
// //                         height: 35,
// //                         decoration: BoxDecoration(
// //                             border: Border.all(color: AppColors.primaryColor),
// //                             borderRadius: BorderRadius.circular(10),
// //                             color: widget.allArticlesModel.author!.following
// //                                 ? AppColors.primaryColor
// //                                 : AppColors.white),
// //                         child: Center(
// //                           child: Text(
// //                             widget.allArticlesModel.author!.following
// //                                 ? "Following"
// //                                 : "Follow",
// //                             style: TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 fontFamily: ConduitFontFamily.robotoRegular,
// //                                 color: widget.allArticlesModel.author!.following
// //                                     ? AppColors.white
// //                                     : AppColors.primaryColor),
// //                           ),
// //                         ),
// //                       ),
// //                       SizedBox(height: 10.0),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         )),
// //       ),
// //     );
// //   }
// // }














// import 'package:conduit/bloc/article_bloc/article_state.dart';
// import 'package:conduit/bloc/my_articles_bloc/my_articles_bloc.dart';
// import 'package:conduit/bloc/my_articles_bloc/my_articles_event.dart';
// import 'package:conduit/bloc/my_articles_bloc/my_articles_state.dart';
// import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_bloc.dart';
// import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_event.dart';
// import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_state.dart';
// import 'package:conduit/bloc/profile_bloc/profile_bloc.dart';
// import 'package:conduit/bloc/profile_bloc/profile_event.dart';
// import 'package:conduit/bloc/profile_bloc/profile_state.dart';
// import 'package:conduit/main.dart';
// import 'package:conduit/repository/all_article_repo.dart';
// import 'package:conduit/ui/EditProfile/EditProfile_screen.dart';
// import 'package:conduit/utils/AppColors.dart';
// import 'package:conduit/utils/message.dart';
// import 'package:conduit/widget/all_article_widget.dart';
// import 'package:conduit/widget/no_internet.dart';
// import 'package:conduit/widget/shimmer_widget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   late ProfileBloc profileBloc;
//   late MyFavoriteArticlesBloc myFavoriteArticlesBloc;
//   late MyArticlesBloc myArticlesBloc;

//   bool myArticle = true;
//   bool favArticle = false;
//   bool isLoading = false;
//   bool isScrollable = false;
//   bool isNoInternet = false;

//   var _myAricleScrollController;
//   var _myFavAricleScrollController;
//   // var _scrollController;
//   int? myAricleLength, myFavAricleLength;

//   void initState() {
//     super.initState();
//     profileBloc = context.read<ProfileBloc>();
//     profileBloc.add(FetchProfileEvent());

//     myArticlesBloc = context.read<MyArticlesBloc>();
//     myArticlesBloc.add(FetchMyArticlesEvent());

//     myFavoriteArticlesBloc = context.read<MyFavoriteArticlesBloc>();
//     myFavoriteArticlesBloc.add(FetchMyFavoriteArticlesEvent());

//     // _scrollController = ScrollController();
//     _myAricleScrollController = ScrollController();
//     _myFavAricleScrollController = ScrollController();

//     _myAricleScrollController.addListener(() async {
//       if (_myAricleScrollController.position.atEdge) {
//         if (_myAricleScrollController.position.pixels ==
//             _myAricleScrollController.position.maxScrollExtent) {
//           myArticlesBloc
//               .add(FetchNextMyArticlesEvent(length: await myAricleLength));
//         }
//       }
//     });

//     _myFavAricleScrollController.addListener(() async {
//       if (_myFavAricleScrollController.position.atEdge) {
//         if (_myFavAricleScrollController.position.pixels ==
//             _myFavAricleScrollController.position.maxScrollExtent) {
//           myFavoriteArticlesBloc.add(FetchNextMyFavoriteArticlesEvent(
//               length: await myFavAricleLength));
//         }
//       }
//     });
//   }

//   // late final _tabController = TabController(length: 2, vsync: this);
//   // final pages = [const MyArticlescreen(), FavoriteScreen()];

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => true,
//       child: Scaffold(
//         backgroundColor: AppColors.white2,
//         extendBody: true,
//         appBar: AppBar(
//           backgroundColor: AppColors.primaryColor,
//           centerTitle: false,
//           automaticallyImplyLeading: favArticle,
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(Icons.arrow_back),
//           ),
//           title: Text(
//             "Profile",
//             style: TextStyle(
//               color: AppColors.white,
//               fontFamily: ConduitFontFamily.robotoRegular,
//             ),
//           ),
//         ),
//         body: isNoInternet
//             ? NoInternet()
//             : ScrollConfiguration(
//                 behavior: NoGlow(),
//                 child: NestedScrollView(
//                   // physics: isScrollable ? null : NeverScrollableScrollPhysics(),
//                   controller: myArticle
//                       ? _myAricleScrollController
//                       : _myFavAricleScrollController,
//                   headerSliverBuilder: ((context, innerBoxIsScrolled) {
//                     return [
//                       SliverAppBar(
//                         pinned: true,
//                         snap: false,
//                         floating: true,
//                         elevation: 0,
//                         automaticallyImplyLeading: false,
//                         backgroundColor: AppColors.white2,
//                         expandedHeight: 320,
//                         bottom: AppBar(
//                           centerTitle: true,
//                           automaticallyImplyLeading: false,
//                           titleSpacing: 6,
//                           elevation: 0,
//                           backgroundColor: AppColors.white2,
//                           title: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 5, horizontal: 10),
//                               child:
//                                   BlocConsumer<MyArticlesBloc, MyArticlesState>(
//                                 listener: (context, state) {
//                                   if (state is MyArticlesNoInternateState) {
//                                     setState(() {
//                                       isNoInternet = true;
//                                     });
//                                   }
//                                 },
//                                 builder: (context, state) {
//                                   if (state is NoArticleState) {
//                                     return Container();
//                                   }
//                                   if (state is MyArticlesLoadingState) {
//                                     return Container(
//                                       height: 40,
//                                       decoration: BoxDecoration(
//                                           color: AppColors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(5)),
//                                       child: Row(
//                                         children: [
//                                           Expanded(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 7,
//                                                       horizontal: 10),
//                                               child: Container(
//                                                   height: 30,
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               5)),
//                                                   child: ShimmerWidget()),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 7,
//                                                       horizontal: 10),
//                                               child: Container(
//                                                   height: 30,
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               5)),
//                                                   child: ShimmerWidget()),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   }
//                                   if (state is MyArticlesLoadedState) {
//                                     return Container(
//                                       height: 40,
//                                       decoration: BoxDecoration(
//                                           color: AppColors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(5)),
//                                       child: Row(
//                                         children: [
//                                           Expanded(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 7,
//                                                       horizontal: 10),
//                                               child: InkWell(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     myArticle = true;
//                                                     favArticle = false;
//                                                   });
//                                                 },
//                                                 child: Container(
//                                                   height: 30,
//                                                   decoration: BoxDecoration(
//                                                       border: Border.all(
//                                                           color: AppColors
//                                                               .primaryColor),
//                                                       color: myArticle
//                                                           ? AppColors
//                                                               .primaryColor
//                                                           : AppColors.white,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               5)),
//                                                   child: Center(
//                                                       child: Text(
//                                                     "My Articles",
//                                                     style: TextStyle(
//                                                       color: myArticle
//                                                           ? AppColors.white
//                                                           : AppColors.black,
//                                                       fontSize: 15,
//                                                       fontFamily:
//                                                           ConduitFontFamily
//                                                               .robotoRegular,
//                                                     ),
//                                                   )),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 7,
//                                                       horizontal: 10),
//                                               child: InkWell(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     myArticle = false;
//                                                     favArticle = true;
//                                                   });
//                                                 },
//                                                 child: Container(
//                                                   height: 30,
//                                                   decoration: BoxDecoration(
//                                                       border: Border.all(
//                                                           color: AppColors
//                                                               .primaryColor),
//                                                       color: favArticle
//                                                           ? AppColors
//                                                               .primaryColor
//                                                           : AppColors.white,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               5)),
//                                                   child: Center(
//                                                     child: Text(
//                                                       "FavArticle Articles",
//                                                       style: TextStyle(
//                                                         color: favArticle
//                                                             ? AppColors.white
//                                                             : AppColors.black,
//                                                         fontSize: 15,
//                                                         fontFamily:
//                                                             ConduitFontFamily
//                                                                 .robotoRegular,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   }
//                                   return Container();
//                                 },
//                               )),
//                           flexibleSpace: FlexibleSpaceBar(
//                             background: SizedBox(
//                                 child: BlocConsumer<ProfileBloc, ProfileState>(
//                               listener: (context, state) {
//                                 // TODO: implement listener
//                                 if (state is ProfileErrorState) {
//                                   CToast.instance
//                                       .showError(context, state.message);
//                                 }
//                                 if (state is ProfileNoInternetState) {
//                                   setState(() {
//                                     isNoInternet = true;
//                                   });
//                                 }
//                               },
//                               builder: (context, state) {
//                                 if (state is ProfileInitialState ||
//                                     state is ProfileLoadingState) {
//                                   return Padding(
//                                     padding: EdgeInsets.only(
//                                         left: 15, right: 15, top: 10),
//                                     child: Container(
//                                       width: MediaQuery.of(context).size.width,
//                                       decoration: BoxDecoration(
//                                         color: AppColors.white,
//                                         // border: Border.all(
//                                         //     color: AppColors.black.withOpacity(0.1)),
//                                         borderRadius: BorderRadius.circular(5),
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 10,
//                                             right: 10,
//                                             top: 20,
//                                             bottom: 10),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                                 height: 80,
//                                                 width: 80,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(50),
//                                                   // border: Border.all(
//                                                   //   color: AppColors.primaryColor,
//                                                   //   width: 1,
//                                                   // ),
//                                                 ),
//                                                 child: ShimmerWidget()),
//                                             SizedBox(height: 20),
//                                             Container(
//                                                 height: 15,
//                                                 width: 150,
//                                                 child: ShimmerWidget()),
//                                             SizedBox(height: 15),
//                                             Container(
//                                                 height: 40,
//                                                 width: MediaQuery.of(context)
//                                                     .size
//                                                     .width,
//                                                 child: ShimmerWidget()),
//                                             SizedBox(height: 18),
//                                             Align(
//                                               alignment: Alignment.centerRight,
//                                               child: Container(
//                                                   height: 25,
//                                                   width: 180,
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             5),
//                                                   ),
//                                                   child: ShimmerWidget()),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }
//                                 if (state is ProfileLoadedState) {
//                                   return Column(
//                                     children: [
//                                       Padding(
//                                         padding: EdgeInsets.only(
//                                             left: 15, right: 15, top: 10),
//                                         child: Container(
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           decoration: BoxDecoration(
//                                             color: AppColors.white,
//                                             border: Border.all(
//                                                 color: AppColors.black
//                                                     .withOpacity(0.1)),
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 10,
//                                                 right: 10,
//                                                 top: 20,
//                                                 bottom: 10),
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               children: [
//                                                 Container(
//                                                   height: 80,
//                                                   width: 80,
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             50),
//                                                     border: Border.all(
//                                                       color: AppColors
//                                                           .primaryColor,
//                                                       width: 1,
//                                                     ),
//                                                   ),
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             1.0),
//                                                     child: ClipRRect(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               50),
//                                                       child: Image.network(
//                                                         '${state.profileList.last.user!.image}',
//                                                         alignment:
//                                                             Alignment.center,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(height: 20),
//                                                 Text(
//                                                   "${state.profileList.last.user!.username}",
//                                                   style: TextStyle(
//                                                     fontSize: 16,
//                                                     fontFamily:
//                                                         ConduitFontFamily
//                                                             .robotoBold,
//                                                   ),
//                                                 ),
//                                                 SizedBox(height: 10),
//                                                 TextFormField(
//                                                   autofocus: false,
//                                                   maxLines: 3,
//                                                   readOnly: true,
//                                                   textAlign: TextAlign.center,
//                                                   enableInteractiveSelection:
//                                                       false,
//                                                   toolbarOptions:
//                                                       ToolbarOptions(
//                                                           copy: false,
//                                                           cut: false,
//                                                           paste: false,
//                                                           selectAll: false),
//                                                   minLines: 1,
//                                                   initialValue: state
//                                                       .profileList
//                                                       .last
//                                                       .user!
//                                                       .bio,
//                                                   // cursorColor: AppColors.primaryColor,
//                                                   keyboardType:
//                                                       TextInputType.text,
//                                                   style: TextStyle(
//                                                       color: Colors.black,
//                                                       fontSize: 12),
//                                                   decoration: InputDecoration(
//                                                     filled: true,
//                                                     fillColor: AppColors.white2,
//                                                     contentPadding:
//                                                         const EdgeInsets.all(5),
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10)),
//                                                     disabledBorder:
//                                                         OutlineInputBorder(
//                                                       borderSide: BorderSide(
//                                                           width: 3,
//                                                           color:
//                                                               AppColors.white2),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                     ),
//                                                     focusedBorder:
//                                                         OutlineInputBorder(
//                                                       borderSide: BorderSide(
//                                                           width: 3,
//                                                           color:
//                                                               AppColors.white2),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                     ),
//                                                     enabledBorder:
//                                                         OutlineInputBorder(
//                                                       borderSide: BorderSide(
//                                                           width: 3,
//                                                           color:
//                                                               AppColors.white2),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                     ),
//                                                     errorBorder:
//                                                         OutlineInputBorder(
//                                                       borderSide: BorderSide(
//                                                           width: 3,
//                                                           color:
//                                                               AppColors.white2),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                     ),
//                                                     focusedErrorBorder:
//                                                         OutlineInputBorder(
//                                                       borderSide: BorderSide(
//                                                           width: 3,
//                                                           color:
//                                                               AppColors.white2),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 // ReadMoreText(
//                                                 //   '${state.profileList.last.bio}',
//                                                 //   textAlign: TextAlign.center,
//                                                 //   trimLines: 2,
//                                                 //   colorClickableText: Colors.pink,
//                                                 //   trimMode: TrimMode.Line,
//                                                 //   trimCollapsedText: 'Show more',
//                                                 //   trimExpandedText: ' Show less',
//                                                 //   lessStyle: TextStyle(
//                                                 //       fontSize: 14,
//                                                 //       color: Colors.blue,
//                                                 //       fontWeight: FontWeight.normal),
//                                                 //   moreStyle: TextStyle(
//                                                 //       fontSize: 14,
//                                                 //       color: Colors.blue,
//                                                 //       fontWeight: FontWeight.normal),
//                                                 // ),
//                                                 SizedBox(height: 15),
//                                                 InkWell(
//                                                   child: Align(
//                                                     alignment:
//                                                         Alignment.centerRight,
//                                                     child: InkWell(
//                                                       onTap: () {
//                                                         Navigator.push(
//                                                           context,
//                                                           CupertinoPageRoute(
//                                                             builder: (context) =>
//                                                                 BlocProvider(
//                                                               create: (context) =>
//                                                                   ProfileBloc(
//                                                                       repo:
//                                                                           AllArticlesImpl()),
//                                                               child:
//                                                                   EditProfileScreen(),
//                                                             ),
//                                                           ),
//                                                         );
//                                                       },
//                                                       child: Container(
//                                                         height: 25,
//                                                         width: 180,
//                                                         decoration:
//                                                             BoxDecoration(
//                                                           border: Border.all(
//                                                             color: AppColors
//                                                                 .primaryColor,
//                                                           ),
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(5),
//                                                         ),
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             Icon(
//                                                               Icons.settings,
//                                                               size: 20,
//                                                             ),
//                                                             SizedBox(width: 10),
//                                                             Text(
//                                                                 "Edit Profile Setting"),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   );
//                                 }
//                                 return Container();
//                               },
//                             )),
//                           ),
//                         ),
//                       ),
//                     ];
//                   }),
//                   body: ScrollConfiguration(
//                     behavior: NoGlow(),
//                     child: SingleChildScrollView(
//                       // physics: isScrollable ? null : NeverScrollableScrollPhysics(),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (myArticle)
//                             BlocConsumer<MyArticlesBloc, MyArticlesState>(
//                               listener: (context, state) {
//                                 // TODO: implement listener
//                                 if (state is MyArticlesNoInternateState) {
//                                   setState(() {
//                                     isNoInternet = true;
//                                   });
//                                 }
//                               },
//                               builder: (context, state) {
//                                 if (state is MyArticlesInitialState ||
//                                     state is MyArticlesLoadingState) {
//                                   return Padding(
//                                     padding: const EdgeInsets.all(5),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(7),
//                                       child: ListView.separated(
//                                         scrollDirection: Axis.vertical,
//                                         itemCount: 3,
//                                         primary: false,
//                                         shrinkWrap: true,
//                                         itemBuilder: (context, index) {
//                                           return AllAirtistWidget.shimmer();
//                                         },
//                                         separatorBuilder:
//                                             (BuildContext context, int index) {
//                                           return SizedBox(height: 10);
//                                         },
//                                       ),
//                                     ),
//                                   );
//                                   // Padding(
//                                   //     padding: const EdgeInsets.only(top: 150),
//                                   //     child: CToast.instance.showLoader());
//                                 }
//                                 if (state is NoMyArticlesState) {
//                                   return Center(
//                                     child: Text("No articles are here... yet"),
//                                   );
//                                 }
//                                 if (state is MyArticlesLoadedState) {
//                                   return Padding(
//                                     padding: const EdgeInsets.only(
//                                       bottom: 10,
//                                       left: 15,
//                                       right: 15,
//                                     ),
//                                     child: ListView.separated(
//                                       primary: false,
//                                       shrinkWrap: true,
//                                       reverse: true,
//                                       padding: EdgeInsets.zero,
//                                       scrollDirection: Axis.vertical,
//                                       itemCount: !state.hasReachedMax
//                                           ? state.myArticleslist.length + 1
//                                           : state.myArticleslist.length,
//                                       itemBuilder: (context, index) {
//                                         if (index <
//                                             state.myArticleslist.length) {
//                                           myAricleLength =
//                                               state.myArticleslist.length;
//                                           return AllAirtistWidget(
//                                             articlesModel:
//                                                 state.myArticleslist[index],
//                                           );
//                                         } else {
//                                           return _buildLoadMoreIndicator();
//                                         }
//                                       },
//                                       separatorBuilder:
//                                           (BuildContext context, int index) {
//                                         return SizedBox(height: 10);
//                                       },
//                                     ),
//                                   );
//                                 }
//                                 return Container();
//                               },
//                             ),
//                           if (favArticle)
//                             BlocConsumer<MyFavoriteArticlesBloc,
//                                 MyFavoriteArticlesState>(
//                               listener: (context, state) {
//                                 // TODO: implement listener
//                                 if (state
//                                     is MyFavoriteArticlesNoInternetState) {
//                                   setState(() {
//                                     isNoInternet = true;
//                                   });
//                                 }
//                               },
//                               builder: (context, state) {
//                                 if (state is MyFavoriteArticlesInitialState ||
//                                     state is MyFavoriteArticlesLoadingState) {
//                                   return Padding(
//                                     padding: const EdgeInsets.all(5),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(7),
//                                       child: ListView.separated(
//                                         scrollDirection: Axis.vertical,
//                                         itemCount: 3,
//                                         primary: false,
//                                         shrinkWrap: true,
//                                         itemBuilder: (context, index) {
//                                           return AllAirtistWidget.shimmer();
//                                         },
//                                         separatorBuilder:
//                                             (BuildContext context, int index) {
//                                           return SizedBox(height: 10);
//                                         },
//                                       ),
//                                     ),
//                                   );
//                                   //  Padding(
//                                   //     padding: const EdgeInsets.only(top: 150),
//                                   //     child: CToast.instance.showLoader());
//                                 }

//                                 if (state is NoMyFavoriteArticlesState) {
//                                   return Center(
//                                     child: Text(
//                                       "No articles are here... yet",
//                                       style: TextStyle(
//                                         fontFamily:
//                                             ConduitFontFamily.robotoRegular,
//                                       ),
//                                     ),
//                                   );
//                                 }
//                                 if (state is MyFavoriteArticlesLoadedStete) {
//                                   return Padding(
//                                     padding: const EdgeInsets.only(
//                                       bottom: 10,
//                                       left: 15,
//                                       right: 15,
//                                     ),
//                                     child: ListView.separated(
//                                       primary: false,
//                                       shrinkWrap: true,

//                                       padding: EdgeInsets.zero,
//                                       scrollDirection: Axis.vertical,
//                                       // physics: const AlwaysScrollableScrollPhysics(),
//                                       itemCount: !state.hasReachedMax
//                                           ? state.myFavoriteArticleslist
//                                                   .length +
//                                               10
//                                           : state.myFavoriteArticleslist.length,
//                                       // state.myFavoriteArticleslist.length +
//                                       //     (state.hasReachedMax ? 0 : 1),
//                                       itemBuilder: (context, index) {
//                                         if (index <
//                                             state.myFavoriteArticleslist
//                                                 .length) {
//                                           myFavAricleLength = state
//                                               .myFavoriteArticleslist.length;
//                                           return AllAirtistWidget(
//                                               articlesModel:
//                                                   state.myFavoriteArticleslist[
//                                                       index]);
//                                         } else {
//                                           return _buildLoadMoreIndicator();
//                                         }
//                                       },
//                                       separatorBuilder:
//                                           (BuildContext context, int index) {
//                                         return SizedBox(height: 10);
//                                       },
//                                     ),
//                                   );
//                                 }
//                                 return Container();
//                               },
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }


//   @override
//   void dispose() {
//     _myAricleScrollController.dispose();
//     _myFavAricleScrollController.dispose();
//     super.dispose();
//   }
// }

// class NoGlow extends ScrollBehavior {
//   @override
//   Widget buildOverscrollIndicator(
//       BuildContext context, Widget child, ScrollableDetails details) {
//     return child;
//   }
// }
