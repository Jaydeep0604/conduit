import 'package:conduit/bloc/comment_bloc/comment_bloc.dart';
import 'package:conduit/model/all_artist_model.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:conduit/ui/home/globle_item_detail_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AllAirtistWidget extends StatefulWidget {
  AllAirtistWidget({Key? key, this.articlesModel, this.isLoading = false})
      : super(key: key);
  AllArticlesModel? articlesModel;
  bool isLoading;

  factory AllAirtistWidget.shimmer() => AllAirtistWidget(isLoading: true);

  @override
  State<AllAirtistWidget> createState() => _AllAirtistWidgetState();
}

class _AllAirtistWidgetState extends State<AllAirtistWidget> {
  bool _obsecureText = true;
  @override
  void _toggleObscured() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Container(
        height: 110.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            //border: Border.all(color: AppColors.black.withOpacity(0.051)),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.w),
              child: Container(
                height: 45.h,
                width: MediaQuery.of(context).size.width,
                child: Shimmer.fromColors(
                  baseColor: AppColors.white2,
                  highlightColor: Colors.white30.withOpacity(0.1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.w),
              child: Container(
                height: 10.h,
                child: Shimmer.fromColors(
                  baseColor: AppColors.white2,
                  highlightColor: Colors.white30.withOpacity(0.1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.w, left: 10.w, right: 10..w),
              child: Container(
                height: 10.h,
                child: Shimmer.fromColors(
                  baseColor: AppColors.white2,
                  highlightColor: Colors.white30.withOpacity(0.1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  child: Container(
                    height: 20.h,
                    width: 100.w,
                    child: Shimmer.fromColors(
                      baseColor: AppColors.white2,
                      highlightColor: Colors.white30.withOpacity(0.1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 20.h,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.w),
                    child: ListView.separated(
                      reverse: true,
                      shrinkWrap: true,
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Container(
                          height: 20.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: AppColors.white2),
                          child: Shimmer.fromColors(
                            baseColor: AppColors.white2,
                            highlightColor: Colors.white30.withOpacity(0.1),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: 5.w,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            )
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => CommentBloc(repo: AllArticlesImpl()),
              child: GlobalItemDetailScreen(
                  slug: widget.articlesModel!.slug!,
                  favorited: widget.articlesModel!.favorited),
            ),
          ),
        );
      },
      onDoubleTap: () {
        _toggleObscured();
      },
      child: Container(
        // height: 160.h,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.black.withOpacity(0.051)),
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 45.h,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w, top: 5.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CircleAvatar(
                        radius: 15,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                              "${widget.articlesModel?.author?.image}"),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 55.w, top: 9.w),
                    child: Container(
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "${widget.articlesModel?.author?.username.toString()}",
                                style: TextStyle(fontSize: 16.sp),
                              )),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "${widget.articlesModel?.createdAt.toString().trimLeft()}",
                                style: TextStyle(
                                    fontSize: 11.sp, color: AppColors.text_color),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(left: 175.w, top: 0.w),
                      child: GestureDetector(
                        onTap: _toggleObscured,
                        child: Transform.scale(
                          scale: 0.4,
                          child: Container(
                            child: _obsecureText
                                ? Icon(
                                    Icons.favorite_outline,
                                    size: 60,
                                    color: AppColors.primaryColor,
                                  )
                                : Icon(
                                    Icons.favorite,
                                    color: AppColors.primaryColor,
                                    size: 60,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.w),
              child: Container(
                child: Text(
                  "${widget.articlesModel?.title}",
                  maxLines: 2,
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.w, left: 10.w, right: 10.w),
              child: Container(
                child: Text(
                  "${widget.articlesModel?.body}",
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.text_color,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Row(
              children: [
                Container(
                  height: 20.h,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      "Read more...",
                      style: TextStyle(fontSize: 11.sp, color: AppColors.black),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  height: 20.h,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: ListView.separated(
                      reverse: true,
                      shrinkWrap: true,
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.articlesModel!.tagList!.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppColors.white2),
                            child: Center(
                                child: Padding(
                              padding:  EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 3.w),
                              child: Text(
                                " ${widget.articlesModel?.tagList![index]} ",
                                style: TextStyle(fontSize: 11.sp),
                              ),
                            )));
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: 5.w,
                        );
                      },
                    ),
                  ),
                )),
              ],
            ),
            SizedBox(
              height: 5.h,
            )
          ],
        ),
      ),
    );
  }
}
