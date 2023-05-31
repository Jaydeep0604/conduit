import 'package:conduit/bloc/my_articles_bloc/my_articles_bloc.dart';
import 'package:conduit/bloc/my_articles_bloc/my_articles_event.dart';
import 'package:conduit/bloc/my_articles_bloc/my_articles_state.dart';
import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_bloc.dart';
import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_event.dart';
import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_state.dart';
import 'package:conduit/bloc/profile_bloc/profile_bloc.dart';
import 'package:conduit/bloc/profile_bloc/profile_event.dart';
import 'package:conduit/bloc/profile_bloc/profile_state.dart';
import 'package:conduit/ui/setting/setting_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/all_airtist_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileBloc profileBloc;
  late MyFavoriteArticlesBloc myFavoriteArticlesBloc;
  late MyArticlesBloc myArticlesBloc;

  bool myArticle = true;
  bool favArticle = false;
  bool isLoading = false;

  var _myAricleScrollController, _myFavAricleScrollController;
  int? myAricleLength, myFavAricleLength;

  void initState() {
    super.initState();
    profileBloc = context.read<ProfileBloc>();
    profileBloc.add(FetchProfileEvent());

    myArticlesBloc = context.read<MyArticlesBloc>();
    myArticlesBloc.add(FetchMyArticlesEvent());

    myFavoriteArticlesBloc = context.read<MyFavoriteArticlesBloc>();
    myFavoriteArticlesBloc.add(FetchMyFavoriteArticlesEvent());

    _myAricleScrollController = ScrollController();
    _myFavAricleScrollController = ScrollController();

    _myAricleScrollController.addListener(() async {
      if (_myAricleScrollController.position.atEdge) {
        if (_myAricleScrollController.position.pixels ==
            _myAricleScrollController.position.maxScrollExtent) {
          myArticlesBloc
              .add(FetchNextMyArticlesEvent(length: await myAricleLength));
        }
      }
    });

    _myFavAricleScrollController = ScrollController();
    _myFavAricleScrollController.addListener(() async {
      if (_myFavAricleScrollController.position.atEdge) {
        if (_myFavAricleScrollController.position.pixels ==
            _myFavAricleScrollController.position.maxScrollExtent) {
          myFavoriteArticlesBloc.add(FetchNextMyFavoriteArticlesEvent(
              length: await myFavAricleLength));
        }
      }
    });
  }

  // late final _tabController = TabController(length: 2, vsync: this);
  // final pages = [const MyArticlescreen(), FavoriteScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(color: AppColors.primaryColor2, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: myArticle
              ? _myAricleScrollController
              : _myFavAricleScrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileErrorState) {
                    // CToast.instance.showError(context, state.message);
                  }
                  if (state is ProfileInitialState ||
                      state is ProfileLoadingState) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: CToast.instance.showLoader(),
                        ));
                  }
                  if (state is ProfileLoadedState) {
                    return Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 15, right: 15, top: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: AppColors.white2,
                              border: Border.all(
                                  color: AppColors.black.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 20, bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color: AppColors.primaryColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          '${state.profileList.last.image}',
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "${state.profileList.last.username}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ReadMoreText(
                                    '${state.profileList.last.bio}',
                                    textAlign: TextAlign.center,
                                    trimLines: 2,
                                    colorClickableText: Colors.pink,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Show more',
                                    trimExpandedText: ' Show less',
                                    lessStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.normal),
                                    moreStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(height: 15),
                                  InkWell(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SettingScreen(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 25,
                                          width: 180,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColors.primaryColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.settings,
                                                size: 20,
                                              ),
                                              SizedBox(width: 10),
                                              Text("Edit Profile Setting"),
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
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Container(
                            height: 40,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          myArticle = true;
                                          favArticle = false;
                                        });
                                      },
                                      child: Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.primaryColor),
                                            color: myArticle
                                                ? AppColors.primaryColor
                                                : AppColors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child:
                                            Center(child: Text("My Articles")),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          myArticle = false;
                                          favArticle = true;
                                        });
                                      },
                                      child: Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.primaryColor),
                                            color: favArticle
                                                ? AppColors.primaryColor
                                                : AppColors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child:
                                            Center(child: Text("My Articles")),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (myArticle)
                          BlocBuilder<MyArticlesBloc, MyArticlesState>(
                            builder: (context, state) {
                              if (state is MyArticlesInitialState ||
                                  state is MyArticlesLoadingState) {
                                return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(7),
                                      child: ListView.separated(
                                        scrollDirection: Axis.vertical,
                                        itemCount: 5,
                                        itemBuilder: (context, index) {
                                          return AllAirtistWidget.shimmer();
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return SizedBox(height: 10);
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (state is NoMyArticlesState) {
                                return Center(
                                  child: Text("No articles are here... yet"),
                                );
                              }
                              if (state is MyArticlesLoadedStete) {
                                return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(7),
                                          child: ListView.separated(
                                            primary: false,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: !state.hasReachedMax
                                                ? state.myArticleslist.length +
                                                    1
                                                : state.myArticleslist.length,
                                            // state.myArticleslist.length +
                                            //     (state.hasReachedMax ? 0 : 1),
                                            itemBuilder: (context, index) {
                                              if (index <
                                                  state.myArticleslist.length) {
                                                myAricleLength =
                                                    state.myArticleslist.length;
                                                return AllAirtistWidget(
                                                    articlesModel: state
                                                        .myArticleslist[index]);
                                              } else {
                                                return _buildLoadMoreIndicator();
                                              }
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return SizedBox(height: 10);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return SizedBox();
                            },
                          ),
                        if (favArticle)
                          BlocBuilder<MyFavoriteArticlesBloc,
                              MyFavoriteArticlesState>(
                            builder: (context, state) {
                              if (state is MyFavoriteArticlesInitialState ||
                                  state is MyFavoriteArticlesLoadingState) {
                                return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(7),
                                      child: ListView.separated(
                                        scrollDirection: Axis.vertical,
                                        itemCount: 5,
                                        itemBuilder: (context, index) {
                                          return AllAirtistWidget.shimmer();
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return SizedBox(height: 10);
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (state is NoMyFavoriteArticlesState) {
                                return Center(
                                  child: Text("No articles are here... yet"),
                                );
                              }
                              if (state is MyFavoriteArticlesLoadedStete) {
                                return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(7),
                                          child: ListView.separated(
                                            primary: false,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            // physics: const AlwaysScrollableScrollPhysics(),
                                            itemCount: !state.hasReachedMax
                                                ? state.myFavoriteArticleslist
                                                        .length +
                                                    10
                                                : state.myFavoriteArticleslist
                                                    .length,
                                            // state.myFavoriteArticleslist.length +
                                            //     (state.hasReachedMax ? 0 : 1),
                                            itemBuilder: (context, index) {
                                              if (index <
                                                  state.myFavoriteArticleslist
                                                      .length) {
                                                myFavAricleLength = state
                                                    .myFavoriteArticleslist
                                                    .length;
                                                return AllAirtistWidget(
                                                    articlesModel: state
                                                            .myFavoriteArticleslist[
                                                        index]);
                                              } else {
                                                return _buildLoadMoreIndicator();
                                              }
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return SizedBox(height: 10);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return SizedBox();
                            },
                          ),
                      ],
                    );
                  }
                  return SizedBox();
                },
              ),

              // TabBar(
              //   controller: _tabController,
              //   indicatorColor: AppColors.primaryColor,
              //   isScrollable: false,
              //   labelColor: AppColors.primaryColor,
              //   unselectedLabelColor: AppColors.text_color,
              //   tabs: [
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Container(
              //         child: Text(
              //           "My Articles",
              //           textAlign: TextAlign.center,
              //           style: TextStyle(fontSize: 14),
              //         ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Expanded(
              //         child: Container(
              //           child: Text("Favorited Articles",
              //               textAlign: TextAlign.center,
              //               style: TextStyle(fontSize: 14)),
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              //   child: Divider(),
              // ),
              // Expanded(
              //   child: TabBarView(
              //     controller: _tabController,
              //     children: [
              //       MyArticlescreen(),
              //       FavoriteScreen(),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return SizedBox(
      height: 30,
      child: CToast.instance.showLoader(),
    );
  }

  @override
  void dispose() {
    _myAricleScrollController.dispose();
    _myFavAricleScrollController.dispose();
    super.dispose();
  }
}
