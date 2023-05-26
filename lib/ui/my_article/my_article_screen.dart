import 'package:conduit/bloc/my_articles_bloc/my_articles_bloc.dart';
import 'package:conduit/bloc/my_articles_bloc/my_articles_event.dart';
import 'package:conduit/bloc/my_articles_bloc/my_articles_state.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/all_airtist_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyArticlescreen extends StatefulWidget {
  const MyArticlescreen({Key? key}) : super(key: key);

  @override
  State<MyArticlescreen> createState() => _MyArticlescreenState();
}

class _MyArticlescreenState extends State<MyArticlescreen> {
  late ScrollController _scrollController;
  int? length;

  late MyArticlesBloc myArticlesBloc;

  void initState() {
    super.initState();
    myArticlesBloc = context.read<MyArticlesBloc>();
    myArticlesBloc.add(FetchMyArticlesEvent());
    // for fetching next data
    _scrollController = ScrollController();
    _scrollController.addListener(() async {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          myArticlesBloc.add(FetchNextMyArticlesEvent(length: await length));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<MyArticlesBloc, MyArticlesState>(
        builder: (context, state) {
          if (state is MyArticlesInitialState ||
              state is MyArticlesLoadingState) {
            return Center(child: CToast.instance.showLoader());
          }

          if (state is NoMyArticlesState) {
            return Center(
              child: Text("No articles are here... yet"),
            );
          }
          if (state is MyArticlesLoadedStete) {
            return SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
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
                          itemCount: state.myArticleslist.length +
                              (state.hasReachedMax ? 0 : 1),
                          itemBuilder: (context, index) {
                                                if (index < state.myArticleslist.length) {
                              length = state.myArticleslist.length;
                              return AllAirtistWidget(
                                  articlesModel: state.myArticleslist[index]);
                            } else {
                              return _buildLoadMoreIndicator();
                            }
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 10);
                          },
                        ),
                      ),
                    ],
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
      height: 30,
      child: CToast.instance.showLoader(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
