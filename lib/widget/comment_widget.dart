import 'package:conduit/bloc/comment_bloc/comment_bloc.dart';
import 'package:conduit/bloc/comment_bloc/comment_event.dart';
import 'package:conduit/config/hive_store.dart';
import 'package:conduit/main.dart';
import 'package:conduit/model/comment_model.dart';
import 'package:conduit/model/user_model.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class CommentWidget extends StatefulWidget {
  CommentWidget(
      {Key? key,
      required this.commentModel,
      this.deleteWidget,
      required this.slug})
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
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              widget.commentModel.body ?? '',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          Divider(
            color: AppColors.black.withOpacity(0.5),
            height: 0,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  
                  foregroundColor: AppColors.text_color,
                  backgroundImage: AssetImage(
                    "assets/icons/user_foreground.png",
                  ),
                  foregroundImage:
                      NetworkImage(widget.commentModel.author?.image ?? ''),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.commentModel.author?.username ?? '',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy').format(
                        DateTime.parse(widget.commentModel.createdAt ?? ''),
                      ),
                      style: TextStyle(
                        color: AppColors.Box_width_color,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                ValueListenableBuilder(
                  valueListenable:
                      Hive.box<UserAccessData>(hiveStore.userDetailKey)
                          .listenable(),
                  builder: (BuildContext context, dynamic box, Widget? child) {
                    UserAccessData? detail = box.get(hiveStore.userId);
                    return detail!.userName ==
                            widget.commentModel.author!.username
                        ? InkWell(
                            onTap: () {
                              commentBloc.add(deleteCommentEvent(
                                  slug: widget.slug!,
                                  commentId: widget.commentModel.id!));
                            },
                            child: Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.red[400],
                            ),
                          )
                        : SizedBox();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
