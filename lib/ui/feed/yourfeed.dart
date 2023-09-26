import 'package:conduit/bloc/feed_bloc/feed_bloc_screen.dart';
import 'package:conduit/bloc/feed_bloc/feed_event.dart';
import 'package:conduit/bloc/feed_bloc/feed_state.dart';
import 'package:conduit/config/constant.dart';
import 'package:conduit/main.dart';
import 'package:conduit/navigator/tab_items.dart';
import 'package:conduit/ui/base/base_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/functions.dart';
import 'package:conduit/utils/image_string.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/all_article_widget.dart';
import 'package:conduit/widget/no_internet.dart';
import 'package:conduit/widget/theme_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class YourFeedScreen extends StatefulWidget {
  static const yourFeedUrl = '/yourFeed';
  const YourFeedScreen({Key? key}) : super(key: key);

  @override
  State<YourFeedScreen> createState() => _YourFeedScreenState();
}

class _YourFeedScreenState extends State<YourFeedScreen> {
  bool isNoInternet = false;
  late FeedBloc feedBloc;
  late ScrollController _scrollController;
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    feedBloc = context.read<FeedBloc>();
    feedBloc.add(FetchFeedEvent());

    _scrollController.addListener(() async {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        feedBloc.add(FetchNextFeedEvent());
      }
    });
  }

  onRefreshAll() {
    setState(() {
      isNoInternet = false;
      feedBloc.add(FetchFeedEvent());
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
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: false,
        leading: Container(
          child: IconButton(
            onPressed: () async {
              bool isPop =
                  await navigatorKey[BaseScreen.getCurrentTab(context)]!
                      .currentState!
                      .maybePop();
              if (!isPop) {
                BaseScreen.switchTab(context, MyTabItem.globalfeed);
              }
            },
            icon: SvgPicture.asset(
              ic_back_arrow_icon,
              color: AppColors.white,
            ),
          ),
        ),
        title: Text(
          "Your Feed",
          style: TextStyle(
            color: AppColors.white,
            fontFamily: ConduitFontFamily.robotoRegular,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async => true,
        child: ThemeContainer(
          child: ScrollConfiguration(
            behavior: NoGlow(),
            child: isNoInternet
                ? NoInternet(
                    onClickRetry: onRefreshAll,
                  )
                : SafeArea(
                    child: BlocConsumer<FeedBloc, FeedState>(
                      listener: (context, state) {
                        if (state is FeedNoInternetState) {
                          setState(() {
                            isNoInternet = true;
                          });
                          CToast.instance.showError(context, NO_INTERNET);
                        }
                      },
                      builder: (context, state) {
                        if (state is NoFeedState) {
                          return Center(
                            child: Text(
                              "No articles are here... yet.",
                              style: TextStyle(
                                fontFamily: ConduitFontFamily.robotoRegular,
                              ),
                            ),
                          );
                        }
                        if (state is FeedLoadingState) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 0, top: 20),
                            child: Container(
                              child: ListView.separated(
                                itemCount: 5,
                                physics: NeverScrollableScrollPhysics(),
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
                        if (state is FeedLoadedState) {
                          return RefreshIndicator(
                            onRefresh: () {
                              return Future.delayed(Duration(seconds: 1), () {
                                onRefreshAll();
                              });
                            },
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, bottom: 20, top: 20),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.separated(
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: state.allArticleslist.length +
                                        (state.hasReachedMax ? 0 : 1),
                                    itemBuilder: (context, index) {
                                      if (index <
                                          state.allArticleslist.length) {
                                        return AllAirtistWidget(
                                            onRefresh: onRefreshAll,
                                            articlesModel:
                                                state.allArticleslist[index]);
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
                                ),
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
