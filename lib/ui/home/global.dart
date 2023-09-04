import 'dart:async';

import 'package:conduit/bloc/all_articles_bloc/all_articles_bloc.dart';
import 'package:conduit/bloc/all_articles_bloc/all_articles_event.dart';
import 'package:conduit/bloc/all_articles_bloc/all_articles_state.dart';
import 'package:conduit/bloc/like_article_bloc/like_article_bloc.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/all_article_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class GlobalScreen extends StatefulWidget {
  const GlobalScreen({Key? key}) : super(key: key);

  @override
  State<GlobalScreen> createState() => _GlobalScreenState();
}

class _GlobalScreenState extends State<GlobalScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  late AllArticlesBloc articlesBloc;
  late LikeBloc likeBloc;
  int? length;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    articlesBloc = context.read<AllArticlesBloc>();
    likeBloc = context.read<LikeBloc>();

    fetchData();

    _scrollController.addListener(() async {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        articlesBloc.add(FetchNextAllArticlesEvent(length: await length));
      }
    });
  }

  void fetchData() {
    articlesBloc.add(FetchAllArticlesEvent());
  }

  Future<void> handleRefresh() async {
    articlesBloc.add(FetchAllArticlesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AllArticlesBloc, AllArticlesState>(
        builder: (context, state) {
          if (state is AllArticlesInitialState ||
              state is AllArticlesLoadingState) {
            return Padding(
              padding: EdgeInsets.all(5.w),
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(7.w),
                  child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return AllAirtistWidget.shimmer();
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 10.h);
                    },
                  ),
                ),
              ),
            );
          }

          if (state is AllArticlesLoadedStete) {
            return LiquidPullToRefresh(
              key: _refreshIndicatorKey,
              showChildOpacityTransition: false,
              animSpeedFactor: 3.0,
              color: AppColors.primaryColor,
              onRefresh: handleRefresh,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(5.w),
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(7.w),
                      child: Column(
                        children: [
                          ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: state.allArticleslist.length +
                                (state.hasReachedMax ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index < state.allArticleslist.length) {
                                length = state.allArticleslist.length;
                                return AllAirtistWidget(
                                    articlesModel:
                                        state.allArticleslist[index]);
                              } else {
                                return _buildLoadMoreIndicator();
                              }
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(height: 10.h);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return SizedBox(
      height: 30.h,
      child: CToast.instance.showLoader(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
