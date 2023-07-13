// import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_bloc.dart';
// import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_event.dart';
// import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_state.dart';
// import 'package:conduit/utils/message.dart';
// import 'package:conduit/widget/all_airtist_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class FavoriteScreen extends StatefulWidget {
//   const FavoriteScreen({Key? key}) : super(key: key);

//   @override
//   State<FavoriteScreen> createState() => _FavoriteScreenState();
// }

// class _FavoriteScreenState extends State<FavoriteScreen> {
//   late MyFavoriteArticlesBloc myFavoriteArticlesBloc;
//   late ScrollController _scrollController;
//   int? length;
//   void initState() {
//     _scrollController = ScrollController();
//     _scrollController.addListener(() async {
//       if (_scrollController.position.atEdge) {
//         if (_scrollController.position.pixels ==
//             _scrollController.position.maxScrollExtent) {
//           myFavoriteArticlesBloc
//               .add(FetchNextMyFavoriteArticlesEvent(length: await length));
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: BlocBuilder<MyFavoriteArticlesBloc, MyFavoriteArticlesState>(
//           builder: (context, state) {
//             if (state is MyFavoriteArticlesInitialState ||
//                 state is MyFavoriteArticlesLoadingState) {
//               return Center(child: CToast.instance.showLoader());
//             }

//             if (state is NoMyFavoriteArticlesState) {
//               return Center(
//                 child: Text("No articles are here... yet"),
//               );
//             }
//             if (state is MyFavoriteArticlesLoadedStete) {
//               return SingleChildScrollView(
//                 controller: _scrollController,
//                 child: Padding(
//                   padding: const EdgeInsets.all(5.w),
//                   child: Container(
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(7.w),
//                           child: ListView.separated(
//                             primary: false,
//                             shrinkWrap: true,
//                             scrollDirection: Axis.vertical,
//                             // physics: const AlwaysScrollableScrollPhysics(),
//                             itemCount: !state.hasReachedMax
//                                 ? state.myFavoriteArticleslist.length + 10
//                                 : state.myFavoriteArticleslist.length,
//                             // state.myFavoriteArticleslist.length +
//                             //     (state.hasReachedMax ? 0 : 1),
//                             itemBuilder: (context, index) {
//                               if (index < state.myFavoriteArticleslist.length) {
//                                 length = state.myFavoriteArticleslist.length;
//                                 return AllAirtistWidget(
//                                     articlesModel:
//                                         state.myFavoriteArticleslist[index]);
//                               } else {
//                                 return _buildLoadMoreIndicator();
//                               }
//                             },
//                             separatorBuilder:
//                                 (BuildContext context, int index) {
//                               return SizedBox(height: 10);
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }
//             return SizedBox();
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadMoreIndicator() {
//     return SizedBox(
//       height: 30.h,
//       child: CToast.instance.showLoader(),
//     );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
