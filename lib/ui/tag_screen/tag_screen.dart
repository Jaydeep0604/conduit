import 'package:conduit/bloc/tags_bloc/tags_bloc.dart';
import 'package:conduit/bloc/tags_bloc/tags_event.dart';
import 'package:conduit/bloc/tags_bloc/tags_state.dart';
import 'package:conduit/main.dart';
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

class TagScreen extends StatefulWidget {
  static const tagUrl = '/tags';
  TagScreen({Key? key, required this.title}) : super(key: key);
  String? title;

  @override
  State<TagScreen> createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  late TagsBloc tagsBloc;
  bool isNoInternet = false;

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

  onRefreshAll() {
    setState(() {
      isNoInternet = false;
    });
    tagsBloc.add(FetchSearchTagEvent(title: widget.title!));
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
              Navigator.pop(context, true);
            },
            icon: SvgPicture.asset(
              ic_back_arrow_icon,
              color: AppColors.white,
            ),
          ),
          title: Text(
            widget.title!,
            style: TextStyle(
              fontFamily: ConduitFontFamily.robotoRegular,
            ),
          ),
          centerTitle: false,
        ),
        body: ThemeContainer(
          child: isNoInternet
              ? NoInternet(
                  onClickRetry: onRefreshAll,
                )
              : SafeArea(
                  child: BlocConsumer<TagsBloc, TagsState>(
                    listener: (context, state) {
                      if (state is SearchTagNoInternetState) {
                        // CToast.instance.showError(context, NO_INTERNET);
                        setState(() {
                          isNoInternet = true;
                        });
                      }
                    },
                    builder: (context, state) {
                      if (state is SearchNoTagState) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/icons/empty_search.png",
                                height: 80,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "No data found",
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontFamily: ConduitFontFamily.robotoBold,
                                ),
                              )
                            ],
                          ),
                        );
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
                        return ScrollConfiguration(
                          behavior: NoGlow(),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: ListView.separated(
                                primary: false,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                itemCount: state.myFavoriteArticleslist.length,
                                itemBuilder: (context, index) {
                                  return AllAirtistWidget(
                                    onRefresh: (){},
                                    articlesModel:
                                        state.myFavoriteArticleslist[index],
                                  );
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
                      return Container();
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
