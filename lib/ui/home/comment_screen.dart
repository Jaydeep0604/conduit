import 'package:conduit/bloc/comment_bloc/comment_bloc.dart';
import 'package:conduit/bloc/comment_bloc/comment_event.dart';
import 'package:conduit/bloc/comment_bloc/comment_state.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late CommentBloc commentBloc;
  void initState() {
    commentBloc = context.read<CommentBloc>();
    commentBloc.add(fetchCommentEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is CommentErrorState) {
          return CToast.instance.showError(context, state.msg);
        }
        // if (state is CommentLoadingState) {
        //   Center(child: CToast.instance.showLoader());
        // }
        if (state is NoCommentState) {
          return SizedBox();
        }
        if (state is CommentSuccessState) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: state.commentModel.length,
              itemBuilder: (context, index) {
                return CommentWidget(
                  commentModel: state.commentModel[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 10,
                );
              },
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
