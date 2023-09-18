import 'package:conduit/bloc/all_articles_bloc/all_articles_bloc.dart';
import 'package:conduit/bloc/all_articles_bloc/all_articles_state.dart';
import 'package:conduit/bloc/tags_bloc/tags_bloc.dart';
import 'package:conduit/bloc/tags_bloc/tags_event.dart';
import 'package:conduit/bloc/tags_bloc/tags_state.dart';
import 'package:conduit/config/constant.dart';
import 'package:conduit/main.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:conduit/ui/base/home_screen.dart';
import 'package:conduit/ui/tag_screen/tag_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/functions.dart';
import 'package:conduit/utils/image_string.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/all_article_widget.dart';
import 'package:conduit/widget/conduitEditText_widget.dart';
import 'package:conduit/widget/no_internet.dart';
import 'package:conduit/widget/shimmer_widget.dart';
import 'package:conduit/widget/theme_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../bloc/all_articles_bloc/all_articles_event.dart';

class GlobalScreen extends StatefulWidget {
  const GlobalScreen({Key? key}) : super(key: key);

  @override
  State<GlobalScreen> createState() => _GlobalScreenState();
}

class _GlobalScreenState extends State<GlobalScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey();

  late ScrollController _scrollController;
  late AllArticlesBloc articlesBloc;
  late TagsBloc tagsBloc;

  bool isNoInternet = false;

  int? length;
  TextEditingController searchCtr = TextEditingController();
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    articlesBloc = context.read<AllArticlesBloc>();
    articlesBloc.add(FetchAllArticlesEvent());

    tagsBloc = context.read<TagsBloc>();
    tagsBloc.add(FetchAllTagsEvent());
    
    _scrollController.addListener(() async {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        articlesBloc.add(FetchNextAllArticlesEvent(length: await length));
      }
    });
  }

  onRetryData() {
    setState(() {
      isNoInternet = false;
      articlesBloc.add(FetchAllArticlesEvent());
      tagsBloc.add(FetchAllTagsEvent());
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            BaseScreen.openDrawer(context);
          },
          child: Padding(
            padding: EdgeInsets.all(18),
            child: SvgPicture.asset(
              ic_menu_icon,
              color: AppColors.white,
            ),
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "conduit",
              style: TextStyle(
                color: AppColors.primaryColor2,
                fontSize: 30,
                fontFamily: ConduitFontFamily.robotoBold,
              ),
            ),
            Text(
              "A place to share your knowledge.",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontFamily: ConduitFontFamily.robotoRegular,
              ),
            ),
          ],
        ),
      ),
      body: ThemeContainer(
        child: isNoInternet
            ? NoInternet(
                onClickRetry: onRetryData,
              )
            : GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: SafeArea(
                  child: ScrollConfiguration(
                    behavior: NoGlow(),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: ConduitSearchEditText(
                              hint: "Search tags",
                              controller: searchCtr,
                              readOnly: false,
                              textInputAction: TextInputAction.search,
                              onEditingComplete: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (searchCtr.text.length > 0) {
                                  searchCtr.clear();
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) {
                                    return BlocProvider(
                                      create: (context) =>
                                          TagsBloc(repo: AllArticlesImpl()),
                                      child: TagScreen(title: searchCtr.text),
                                    );
                                  }));
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(" "),
                              ],
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          BlocBuilder<TagsBloc, TagsState>(
                            builder: (context, state) {
                              if (state is TagsLoadingState) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Container(
                                            height: 30,
                                            width: 120,
                                            child: ShimmerWidget(),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Wrap(
                                            spacing: 10,
                                            runSpacing: 15,
                                            children: List.generate(
                                              9,
                                              (index) {
                                                return ShimmerWidget(
                                                  height: 30,
                                                  width: 90,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              if (state is TagsErrorState) {
                                print("tag error state");
                                print(state.msg.toString());
                              }
                              if (state is TagsNoInternetState) {
                                return Container();
                              }
                              if (state is TagsSuccessState) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(
                                            "Popular Tags",
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 18,
                                              fontFamily:
                                                  ConduitFontFamily.robotoBold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Wrap(
                                            spacing: 10,
                                            runSpacing: 10,
                                            children: List.generate(
                                              state.allTagsModel.tags!.length,
                                              (index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                        builder: (context) {
                                                          return BlocProvider(
                                                            create: (context) =>
                                                                TagsBloc(
                                                                    repo:
                                                                        AllArticlesImpl()), // Create a new instance
                                                            child: TagScreen(
                                                              title: state
                                                                  .allTagsModel
                                                                  .tags![index],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade600,
                                                      // border: Border.all(
                                                      //   color:
                                                      //       AppColors.black.withOpacity(1),
                                                      // ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 5,
                                                        horizontal: 10,
                                                      ),
                                                      child: Text(
                                                        "${state.allTagsModel.tags![index]}",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              AppColors.white,
                                                          fontFamily:
                                                              ConduitFontFamily
                                                                  .robotoRegular,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Text(
                                "something want wrong",
                                style: TextStyle(
                                  fontFamily: ConduitFontFamily.robotoRegular,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 25),
                          BlocConsumer<AllArticlesBloc, AllArticlesState>(
                            listener: (context, state) {
                              if (state is AllArticlesNoInternateState) {
                                setState(() {
                                  isNoInternet = true;
                                });
                                CToast.instance.showError(context, NO_INTERNET);
                              }
                            },
                            builder: (context, state) {
                              if (state is AllArticlesInitialState ||
                                  state is AllArticlesLoadingState) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, bottom: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ShimmerWidget(
                                        height: 30,
                                        width: 100,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        child: ListView.separated(
                                          // scrollDirection: Axis.vertical,
                                          itemCount: 5,
                                          primary: false,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return AllAirtistWidget.shimmer();
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
                                );
                              }
                              if (state is AllArticlesLoadedStete) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, bottom: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Articles for You",
                                        style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 18,
                                          fontFamily:
                                              ConduitFontFamily.robotoBold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView.separated(
                                          primary: false,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: state
                                                  .allArticleslist.length +
                                              (state.hasReachedMax ? 0 : 1),
                                          itemBuilder: (context, index) {
                                            if (index <
                                                state.allArticleslist
                                                    .length) {
                                              length = state
                                                  .allArticleslist.length;
                                              return AllAirtistWidget(
                                                  articlesModel:
                                                      state.allArticleslist[
                                                          index]);
                                            } else {
                                              return ConduitFunctions.buildLoadMoreIndicator();
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
                                );
                              }
                              if (state is AllArticlesUnAuthorizedState) {
                                ConduitFunctions.logOut(context);
                              }
                              return Container();
                            },
                          )
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
