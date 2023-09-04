import 'package:conduit/bloc/tags_bloc/tags_bloc.dart';
import 'package:conduit/bloc/tags_bloc/tags_event.dart';
import 'package:conduit/bloc/tags_bloc/tags_state.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/all_article_widget.dart';
import 'package:conduit/widget/theme_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagScreen extends StatefulWidget {
  TagScreen({Key? key, required this.title}) : super(key: key);
  String? title;

  @override
  State<TagScreen> createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  late TagsBloc tagsBloc;

  @override
  void initState() {
    super.initState();
    tagsBloc = context.read<TagsBloc>();
    tagsBloc.add(FetchSearchTagEvent(title: widget.title!));
  }

  @override
  void dispose() {
    tagsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        tagsBloc.close(); // Close the bloc before navigating back
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          title: Text(widget.title!),
          centerTitle: false,
        ),
        body: ThemeContainer(
          child: SafeArea(child: BlocBuilder<TagsBloc, TagsState>(
            builder: (context, state) {
              if (state is SearchNoTagState) {
                return Container();
              }
              if (state is SearchTagLoadingState) {
                return Center(
                  child: CToast.instance.showLoader(),
                );
              }
              if (state is SearchTagErrorState) {
                print(state.msg.toString());
              }
              if (state is SearchTagSuccessState) {
                return SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: state.myFavoriteArticleslist.length,
                      itemBuilder: (context, index) {
                        return AllAirtistWidget(
                          articlesModel: state.myFavoriteArticleslist[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 10);
                      },
                    ),
                  ),
                );
              }
              return Center(child: Text("Something went wrong"));
            },
          )),
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
}
