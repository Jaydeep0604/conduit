import 'package:conduit/main.dart';
import 'package:conduit/navigator/tab_items.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation(
      {Key? key, required this.currentTab, required this.onSelectTab})
      : super(key: key);
  MyTabItem currentTab;
  final ValueChanged<MyTabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    onSelectTab(MyTabItem.globalfeed);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      children: [
                        Icon(
                          CupertinoIcons.globe,
                          size: currentTab == MyTabItem.globalfeed ? 25 : 23,
                          color: currentTab == MyTabItem.globalfeed
                              ? AppColors.primaryColor
                              : AppColors.black.withOpacity(0.7),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "Global Feed",
                          style: TextStyle(
                            fontFamily: ConduitFontFamily.robotoMedium,
                            color: currentTab == MyTabItem.globalfeed
                                ? AppColors.primaryColor
                                : AppColors.black.withOpacity(0.7),
                            fontSize:
                                currentTab == MyTabItem.globalfeed ? 13 : 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    onSelectTab(MyTabItem.yourfeed);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      children: [
                        Icon(
                          CupertinoIcons.doc_text,
                          size: currentTab == MyTabItem.yourfeed ? 25 : 23,
                          color: currentTab == MyTabItem.yourfeed
                              ? AppColors.primaryColor
                              : AppColors.black.withOpacity(0.7),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "Your Feed",
                          style: TextStyle(
                            fontFamily: ConduitFontFamily.robotoMedium,
                            color: currentTab == MyTabItem.yourfeed
                                ? AppColors.primaryColor
                                : AppColors.black.withOpacity(0.7),
                            fontSize:
                                currentTab == MyTabItem.yourfeed ? 13 : 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    onSelectTab(MyTabItem.addarticle);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      children: [
                        Icon(
                          CupertinoIcons.add,
                          size: currentTab == MyTabItem.addarticle ? 25 : 23,
                          color: currentTab == MyTabItem.addarticle
                              ? AppColors.primaryColor
                              : AppColors.black.withOpacity(0.7),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "Add Article",
                          style: TextStyle(
                            fontFamily: ConduitFontFamily.robotoMedium,
                            color: currentTab == MyTabItem.addarticle
                                ? AppColors.primaryColor
                                : AppColors.black.withOpacity(0.7),
                            fontSize:
                                currentTab == MyTabItem.addarticle ? 13 : 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
