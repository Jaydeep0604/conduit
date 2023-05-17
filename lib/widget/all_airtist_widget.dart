import 'package:conduit/model/all_artist_model.dart';
import 'package:conduit/ui/home/globle_item_detail_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';

class AllAirtistWidget extends StatefulWidget {
  AllAirtistWidget({Key? key, required this.articlesModel}) : super(key: key);
  AllArticlesModel articlesModel;

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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                GlobalItemDetailScreen(allArticlesModel: widget.articlesModel),
          ),
        );
      },
      onDoubleTap: (){
        _toggleObscured();
      },
      child: Container(
        // height: 160,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: AppColors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 45,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CircleAvatar(
                        radius: 15,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                              "${widget.articlesModel.author!.image}"),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 55, top: 9),
                    child: Container(
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "${widget.articlesModel.author!.username.toString()}",
                                style: TextStyle(fontSize: 16),
                              )),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "${widget.articlesModel.createdAt.toString().trimLeft()}",
                                style: TextStyle(
                                    fontSize: 11, color: AppColors.text_color),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 175, top: 0),
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
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
              child: Container(
                child: Text(
                  "${widget.articlesModel.slug}",
                  maxLines: 2,
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
              child: Container(
                child: Text(
                  "${widget.articlesModel.body}",
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.text_color,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Container(
                  height: 20,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Read more...",
                      style: TextStyle(fontSize: 11, color: AppColors.black),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  height: 20,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ListView.separated(
                      reverse: true,
                      shrinkWrap: true,
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.articlesModel.tagList!.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppColors.white2),
                            child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 3),
                                  child: Text(
                              " ${widget.articlesModel.tagList![index]} ",
                              style: TextStyle(fontSize: 11),
                            ),
                                )));
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: 5,
                        );
                      },
                    ),
                  ),
                )),
              ],
            ),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}
// Expanded(
//                         flex: 3,
//                         child: Row(
//                           children: [
                            
//                             Container(
//                               height: 15,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(50),
//                                   color: AppColors.white2),
//                               child: Text(
//                                 " ${widget.airtistModel.tagList!.elementAt(0)} ",
//                                 style: TextStyle(fontSize: 11),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Container(
//                               height: 15,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(50),
//                                   color: AppColors.white2),
//                               child: Text(
//                                 " ${widget.airtistModel.tagList!.elementAt(1)} ",
//                                 style: TextStyle(fontSize: 11),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Container(
//                               height: 15,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(50),
//                                   color: AppColors.white2),
//                               child: Text(
//                                 " ${widget.airtistModel.tagList!.elementAt(2)} ",
//                                 style: TextStyle(fontSize: 11),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             // Container(
//                             //   height: 15,
//                             //   decoration: BoxDecoration(
//                             //       borderRadius: BorderRadius.circular(50),
//                             //       color: AppColors.white2),
//                             //   child: Text(
//                             //     "  ",
//                             //     style: TextStyle(fontSize: 11),
//                             //   ),
//                             // ),
//                             // SizedBox(
//                             //   width: 5,
//                             // ),
//                           ],
//                         )),