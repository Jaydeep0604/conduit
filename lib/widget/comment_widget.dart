import 'package:conduit/bloc/comment_bloc/comment_bloc.dart';
import 'package:conduit/bloc/comment_bloc/comment_event.dart';
import 'package:conduit/config/hive_store.dart';
import 'package:conduit/model/comment_model.dart';
import 'package:conduit/model/user_model.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class CommentWidget extends StatefulWidget {
  CommentWidget(
      {Key? key, required this.commentModel,this.deleteWidget, required this.slug})
      : super(key: key);
  CommentModel commentModel;
  String? slug;

  Widget? deleteWidget;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late CommentBloc commentBloc;

  @override
  initState() {
    super.initState();
    commentBloc = context.read<CommentBloc>();

    // commentIdStore();
  }

  // commentIdStore() async {
  //   if (widget.commentModel.id != "")
  //     sharedPreferencesStore.storeCommentId(
  //       await widget.commentModel.id!,
  //     );
  // }

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
            minLines: 1,
            maxLines: null,
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
                  ValueListenableBuilder(
                    valueListenable:
                        Hive.box<UserAccessData>(hiveStore.userDetailKey)
                            .listenable(),
                    builder:
                        (BuildContext context, dynamic box, Widget? child) {
                      UserAccessData? detail = box.get(hiveStore.userId);
                      return detail!.userName ==
                              widget.commentModel.author!.username
                          ? SizedBox(
                              child: InkWell(
                                onTap: () {
                                  commentBloc.add(deleteCommentEvent(
                                      slug: widget.slug!,
                                      commentId:widget.commentModel.id!));
                                },
                                child: Icon(
                                  Icons.delete_forever_rounded,
                                  color: Colors.red[400],
                                ),
                              ),
                            )
                          : SizedBox();
                    },
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
