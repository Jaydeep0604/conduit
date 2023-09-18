import 'package:conduit/bloc/my_articles_bloc/my_articles_bloc.dart';
import 'package:conduit/bloc/my_articles_bloc/my_articles_event.dart';
import 'package:conduit/bloc/my_articles_bloc/my_articles_state.dart';
import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_bloc.dart';
import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_event.dart';
import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_state.dart';
import 'package:conduit/bloc/profile_bloc/profile_bloc.dart';
import 'package:conduit/bloc/profile_bloc/profile_event.dart';
import 'package:conduit/bloc/profile_bloc/profile_state.dart';
import 'package:conduit/main.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:conduit/ui/EditProfile/EditProfile_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/functions.dart';
import 'package:conduit/utils/image_string.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/all_article_widget.dart';
import 'package:conduit/widget/no_internet.dart';
import 'package:conduit/widget/shimmer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

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
  bool isScrollable = false;
  bool isNoInternet = false;

  late ScrollController _myAricleScrollController;
  late ScrollController _myFavAricleScrollController;
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

    // another method of pagenation
    // _myAricleScrollController.addListener(() async {
    //   if (_myAricleScrollController.position.atEdge) {
    //     if (_myAricleScrollController.position.pixels ==
    //         _myAricleScrollController.position.maxScrollExtent) {
    //       myArticlesBloc
    //           .add(FetchNextMyArticlesEvent(length: await myAricleLength));
    //     }
    //   }
    // });

    // _myFavAricleScrollController.addListener(() async {
    //   if (_myFavAricleScrollController.position.atEdge) {
    //     if (_myFavAricleScrollController.position.pixels ==
    //         _myFavAricleScrollController.position.maxScrollExtent) {
    //       myFavoriteArticlesBloc.add(FetchNextMyFavoriteArticlesEvent(
    //           length: await myFavAricleLength));
    //     }
    //   }
    // });
  }

  onFetcharticlesData() {
    if (myArticle) {
      myArticlesBloc.add(FetchMyArticlesEvent());
    } else {
      myFavoriteArticlesBloc.add(FetchMyFavoriteArticlesEvent());
    }
  }

  onRetryData() {
    setState(() {
      isNoInternet = false;
      profileBloc.add(FetchProfileEvent());
      myArticlesBloc.add(FetchMyArticlesEvent());
      myFavoriteArticlesBloc.add(FetchMyFavoriteArticlesEvent());
    });
  }

  @override
  void dispose() {
    _myAricleScrollController.dispose();
    _myFavAricleScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: AppColors.white2,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          centerTitle: false,
          automaticallyImplyLeading: favArticle,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              ic_back_arrow_icon,
              color: AppColors.white,
            ),
          ),
          title: Text(
            "Profile",
            style: TextStyle(
              color: AppColors.white,
              fontFamily: ConduitFontFamily.robotoRegular,
            ),
          ),
        ),
        body: isNoInternet
            ? NoInternet(
                onClickRetry: onRetryData,
              )
            : NestedScrollView(
                physics: isScrollable ? null : NeverScrollableScrollPhysics(),
                headerSliverBuilder: ((context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      pinned: true,
                      snap: false,
                      floating: true,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      backgroundColor: AppColors.white2,
                      expandedHeight: 320,
                      bottom: AppBar(
                        centerTitle: true,
                        automaticallyImplyLeading: false,
                        titleSpacing: 6,
                        elevation: 0,
                        backgroundColor: AppColors.white2,
                        title: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: BlocConsumer<ProfileBloc, ProfileState>(
                            listener: (context, state) {
                              if (state is ProfileNoInternetState) {
                                setState(() {
                                  isNoInternet = true;
                                });
                              }
                              if (state is ProfileLoadingState) {
                                setState(() {
                                  isScrollable = false;
                                });
                              }
                            },
                            builder: (context, state) {
                              if (state is ProfileLoadingState) {
                                return Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7, horizontal: 10),
                                          child: Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: ShimmerWidget()),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7, horizontal: 10),
                                          child: Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: ShimmerWidget()),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              if (state is ProfileLoadedState) {
                                return Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7, horizontal: 10),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                myArticle = true;
                                                favArticle = false;
                                              });
                                              onFetcharticlesData();
                                            },
                                            child: Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppColors
                                                          .primaryColor),
                                                  color: myArticle
                                                      ? AppColors.primaryColor
                                                      : AppColors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Center(
                                                  child: Text(
                                                "My Articles",
                                                style: TextStyle(
                                                  color: myArticle
                                                      ? AppColors.white
                                                      : AppColors.black,
                                                  fontSize: 15,
                                                  fontFamily: ConduitFontFamily
                                                      .robotoRegular,
                                                ),
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7, horizontal: 10),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                myArticle = false;
                                                favArticle = true;
                                              });
                                              onFetcharticlesData();
                                            },
                                            child: Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppColors
                                                          .primaryColor),
                                                  color: favArticle
                                                      ? AppColors.primaryColor
                                                      : AppColors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Center(
                                                child: Text(
                                                  "FavArticle Articles",
                                                  style: TextStyle(
                                                    color: favArticle
                                                        ? AppColors.white
                                                        : AppColors.black,
                                                    fontSize: 15,
                                                    fontFamily:
                                                        ConduitFontFamily
                                                            .robotoRegular,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: SizedBox(
                            child: BlocConsumer<ProfileBloc, ProfileState>(
                          listener: (context, state) {
                            if (state is ProfileErrorState) {
                              CToast.instance.showError(context, state.message);
                            }
                          },
                          builder: (context, state) {
                            if (state is ProfileInitialState ||
                                state is ProfileLoadingState) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    // border: Border.all(
                                    //     color: AppColors.black.withOpacity(0.1)),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 20,
                                        bottom: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              // border: Border.all(
                                              //   color: AppColors.primaryColor,
                                              //   width: 1,
                                              // ),
                                            ),
                                            child: ShimmerWidget()),
                                        SizedBox(height: 20),
                                        Container(
                                            height: 15,
                                            width: 150,
                                            child: ShimmerWidget()),
                                        SizedBox(height: 15),
                                        Container(
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ShimmerWidget()),
                                        SizedBox(height: 18),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                              height: 25,
                                              width: 180,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: ShimmerWidget()),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            if (state is ProfileLoadedState) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 15, right: 15, top: 10),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        border: Border.all(
                                            color: AppColors.black
                                                .withOpacity(0.1)),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 20,
                                            bottom: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                border: Border.all(
                                                  color: AppColors.primaryColor,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.network(
                                                    state.profileList.last.user!
                                                        .image!,
                                                    alignment: Alignment.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              "${state.profileList.last.user!.username}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: ConduitFontFamily
                                                    .robotoBold,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            TextFormField(
                                              autofocus: false,
                                              maxLines: 3,
                                              readOnly: true,
                                              textAlign: TextAlign.center,
                                              enableInteractiveSelection: false,
                                              toolbarOptions: ToolbarOptions(
                                                  copy: false,
                                                  cut: false,
                                                  paste: false,
                                                  selectAll: false),
                                              minLines: 1,
                                              initialValue: state
                                                  .profileList.last.user!.bio,
                                              // cursorColor: AppColors.primaryColor,
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: AppColors.white2,
                                                contentPadding:
                                                    const EdgeInsets.all(5),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 3,
                                                      color: AppColors.white2),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 3,
                                                      color: AppColors.white2),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 3,
                                                      color: AppColors.white2),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 3,
                                                      color: AppColors.white2),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 3,
                                                      color: AppColors.white2),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                            // ReadMoreText(
                                            //   '${state.profileList.last.bio}',
                                            //   textAlign: TextAlign.center,
                                            //   trimLines: 2,
                                            //   colorClickableText: Colors.pink,
                                            //   trimMode: TrimMode.Line,
                                            //   trimCollapsedText: 'Show more',
                                            //   trimExpandedText: ' Show less',
                                            //   lessStyle: TextStyle(
                                            //       fontSize: 14,
                                            //       color: Colors.blue,
                                            //       fontWeight: FontWeight.normal),
                                            //   moreStyle: TextStyle(
                                            //       fontSize: 14,
                                            //       color: Colors.blue,
                                            //       fontWeight: FontWeight.normal),
                                            // ),
                                            SizedBox(height: 15),
                                            InkWell(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                        builder: (context) =>
                                                            BlocProvider(
                                                          create: (context) =>
                                                              ProfileBloc(
                                                                  repo:
                                                                      AllArticlesImpl()),
                                                          child:
                                                              EditProfileScreen(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 25,
                                                    width: 180,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.settings,
                                                          size: 20,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                            "Edit Profile Setting"),
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
                                ],
                              );
                            }
                            return Container();
                          },
                        )),
                      ),
                    ),
                  ];
                }),
                body: ScrollConfiguration(
                  behavior: NoGlow(),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo is ScrollEndNotification &&
                          scrollInfo.metrics.extentAfter == 0) {
                        if (myArticle) {
                          myArticlesBloc.add(FetchNextMyArticlesEvent());
                        } else {
                          myFavoriteArticlesBloc.add(
                            FetchNextMyFavoriteArticlesEvent(),
                          );
                        }
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (myArticle)
                            BlocConsumer<MyArticlesBloc, MyArticlesState>(
                              listener: (context, state) {
                                // TODO: implement listener
                                if (state is MyArticlesNoInternateState) {
                                  setState(() {
                                    isNoInternet = true;
                                  });
                                }
                                if (state is MyArticlesLoadedState) {
                                  setState(() {
                                    isScrollable = true;
                                  });
                                }
                                if (state is MyArticlesLoadingState) {
                                  setState(() {
                                    isScrollable = false;
                                  });
                                }
                                if (state is NoMyArticlesState) {
                                  setState(() {
                                    isScrollable = true;
                                  });
                                }
                              },
                              builder: (context, state) {
                                if (state is MyArticlesInitialState ||
                                    state is MyArticlesLoadingState) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(7),
                                      child: ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: 5,
                                        primary: false,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return AllAirtistWidget.shimmer();
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return SizedBox(height: 10);
                                        },
                                      ),
                                    ),
                                  );
                                }
                                if (state is NoMyArticlesState) {
                                  return SizedBox(
                                    height: 200,
                                    child: Center(
                                      child: Text(
                                        "No articles are here... yet",
                                        style: TextStyle(
                                            fontFamily:
                                                ConduitFontFamily.robotoMedium),
                                      ),
                                    ),
                                  );
                                }
                                if (state is MyArticlesLoadedState) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 10,
                                      left: 15,
                                      right: 15,
                                    ),
                                    child: ListView.separated(
                                      primary: false,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      itemCount: state.myArticleslist.length +
                                          (state.hasReachedMax ? 0 : 1),
                                      itemBuilder: (context, index) {
                                        if (index <
                                            state.myArticleslist.length) {
                                          myAricleLength =
                                              state.myArticleslist.length;
                                          return AllAirtistWidget(
                                            articlesModel:
                                                state.myArticleslist[index],
                                          );
                                        } else {
                                          return ConduitFunctions
                                              .buildLoadMoreIndicator();
                                        }
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(height: 10);
                                      },
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                          if (favArticle)
                            BlocConsumer<MyFavoriteArticlesBloc,
                                MyFavoriteArticlesState>(
                              listener: (context, state) {
                                // TODO: implement listener
                                if (state
                                    is MyFavoriteArticlesNoInternetState) {
                                  setState(() {
                                    isNoInternet = true;
                                  });
                                }
                                if (state is MyFavoriteArticlesLoadingState) {
                                  setState(() {
                                    isScrollable = false;
                                  });
                                }
                                if (state is NoMyFavoriteArticlesState) {
                                  setState(() {
                                    isScrollable = true;
                                  });
                                }
                                if (state is MyFavoriteArticlesLoadedStete) {
                                  setState(() {
                                    isScrollable = true;
                                  });
                                }
                              },
                              builder: (context, state) {
                                if (state is MyFavoriteArticlesInitialState ||
                                    state is MyFavoriteArticlesLoadingState) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(7),
                                      child: ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: 5,
                                        primary: false,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return AllAirtistWidget.shimmer();
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return SizedBox(height: 10);
                                        },
                                      ),
                                    ),
                                  );
                                }
                                if (state is NoMyFavoriteArticlesState) {
                                  return SizedBox(
                                    height: 200,
                                    child: Center(
                                      child: Text(
                                        "No articles are here... yet",
                                        style: TextStyle(
                                          fontFamily:
                                              ConduitFontFamily.robotoMedium,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (state is MyFavoriteArticlesLoadedStete) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 10,
                                      left: 15,
                                      right: 15,
                                    ),
                                    child: ListView.separated(
                                      primary: false,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          state.myFavoriteArticleslist.length +
                                              (state.hasReachedMax ? 0 : 1),
                                      itemBuilder: (context, index) {
                                        if (index <
                                            state.myFavoriteArticleslist
                                                .length) {
                                          myFavAricleLength = state
                                              .myFavoriteArticleslist.length;
                                          return AllAirtistWidget(
                                              articlesModel:
                                                  state.myFavoriteArticleslist[
                                                      index]);
                                        } else {
                                          return ConduitFunctions
                                              .buildLoadMoreIndicator();
                                        }
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(height: 10);
                                      },
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
