import 'package:conduit/config/shared_preferences_store.dart';
import 'package:conduit/model/comment_model.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentWidget extends StatefulWidget {
  CommentWidget(
      {Key? key, required this.commentModel, required this.deleteWidget})
      : super(key: key);
  CommentModel commentModel;

  Widget deleteWidget;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  initState() {
    super.initState();
    commentIdStore();
  }

  commentIdStore() async {
    if (widget.commentModel.id != "")
      sharedPreferencesStore.storeCommentId(
        await widget.commentModel.id!,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: AppColors.black.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          TextFormField(
            maxLines: 1,
            autofocus: false,
            initialValue: "${widget.commentModel.body ?? ''}",
            readOnly: true,
            cursorColor: AppColors.primaryColor,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              //hintText: "Write a comment...",
              filled: true,
              fillColor: AppColors.white2,
              contentPadding: const EdgeInsets.all(10),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(15.0),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: AppColors.white2),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: AppColors.white2),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: AppColors.white2),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: AppColors.white2),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: AppColors.white2),
                borderRadius: BorderRadius.circular(10),
              ),
              //prefixText: 'GJ011685',
            ),
            // controller: emailCtr,
          ),
          Divider(
            color: AppColors.black.withOpacity(0.5),
          ),
          Container(
            decoration: BoxDecoration(
                color: AppColors.white2,
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                          "${widget.commentModel.author?.image ?? ''}"),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${widget.commentModel.author?.username ?? ''}",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd').format(
                        DateTime.parse(widget.commentModel.createdAt ?? '')),
                    style: TextStyle(color: AppColors.Box_width_color),
                  ),
                  Spacer(),
                  SizedBox(
                    child: widget.deleteWidget,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
