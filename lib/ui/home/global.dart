import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/all_airtist_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/all_articles_bloc/all_articles_bloc.dart';
import '../../bloc/all_articles_bloc/all_articles_state.dart';

class GlobalScreen extends StatefulWidget {
  const GlobalScreen({Key? key}) : super(key: key);

  @override
  State<GlobalScreen> createState() => _GlobalScreenState();
}

class _GlobalScreenState extends State<GlobalScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AllArticlesBloc, AllArticlesState>(
        builder: (context, state) {
          if (state is AllArticlesInitialState ||
              state is AllArticlesLoadingState) {
            return Center(child: CToast.instance.showLoader()
                // CircularProgressIndicator(
                //   backgroundColor: Colors.black,
                //   color: AppColors.white2,

                // ),
                );
          }
          if (state is AllArticlesLoadedStete) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: state.allArticleslist.length,
                      itemBuilder: (context, index) {
                        return AllAirtistWidget(
                            articlesModel: state.allArticleslist[index]);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 10,
                        );
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
}
