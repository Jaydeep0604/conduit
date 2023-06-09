import 'package:conduit/bloc/all_articles_bloc/all_articles_bloc.dart';
import 'package:conduit/bloc/all_articles_bloc/all_articles_state.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/all_airtist_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/all_articles_bloc/all_articles_event.dart';

class GlobalScreen extends StatefulWidget {
  const GlobalScreen({Key? key}) : super(key: key);

  @override
  State<GlobalScreen> createState() => _GlobalScreenState();
}

class _GlobalScreenState extends State<GlobalScreen> {
  late ScrollController _scrollController;
  late AllArticlesBloc articlesBloc;
  int? length;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    articlesBloc = context.read<AllArticlesBloc>();
    _scrollController.addListener(() async {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          articlesBloc.add(FetchNextAllArticlesEvent(length: await length));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AllArticlesBloc, AllArticlesState>(
        builder: (context, state) {
          if (state is AllArticlesInitialState ||
              state is AllArticlesLoadingState) {
            return Padding(
              padding:  EdgeInsets.all(5.w),
              child: Container(
                child: Padding(
                  padding:  EdgeInsets.all(7.w),
                  child: ListView.separated(
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
            return SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding:  EdgeInsets.all(5.w),
                child: Container(
                  child: Padding(
                    padding:  EdgeInsets.all(7.w),
                    child: ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: state.allArticleslist.length +
                          (state.hasReachedMax ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index < state.allArticleslist.length) {
                          length = state.allArticleslist.length;

                          return AllAirtistWidget(
                              articlesModel: state.allArticleslist[index]);
                        } else {
                          return _buildLoadMoreIndicator();
                        }
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 10.h);
                      },
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
