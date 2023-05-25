import 'package:conduit/bloc/all_articles_bloc/all_articles_bloc.dart';
import 'package:conduit/bloc/all_articles_bloc/all_articles_state.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/all_airtist_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/all_articles_bloc/all_articles_event.dart';

class GlobalScreen extends StatefulWidget {
  const GlobalScreen({Key? key}) : super(key: key);

  @override
  State<GlobalScreen> createState() => _GlobalScreenState();
}

class _GlobalScreenState extends State<GlobalScreen> {
  late ScrollController _scrollController;
  late AllArticlesBloc ArticlesBloc;
  int? length;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    ArticlesBloc = context.read<AllArticlesBloc>();
    ArticlesBloc.add(FetchAllArticlesEvent());

    _scrollController.addListener(() async {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          ArticlesBloc.add(FetchNextAllArticlesEvent(length: await length));
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
            return Center(child: CToast.instance.showLoader());
          }

          if (state is AllArticlesLoadedStete) {
            return SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(7),
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
                        return SizedBox(height: 10);
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
