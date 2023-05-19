import 'package:conduit/bloc/comment_bloc/comment_bloc.dart';
import 'package:conduit/bloc/comment_bloc/comment_event.dart';
import 'package:conduit/bloc/comment_bloc/comment_state.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late CommentBloc commentBloc;
  @override
  void initState() {
    super.initState();
    commentBloc = context.read<CommentBloc>();
    commentBloc.add(fetchCommentEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocBuilder<CommentBloc, CommentState>(
        builder: (context, state) {
          // if (state is CommentErrorState) {
          //   return CToast.instance.showError(context, state.msg);
          // }
          // if (state is CommentLoadingState) {
          //   Center(child: CToast.instance.showLoader());
          // }
          // if (state is NoCommentState) {
          //   return SizedBox();
          // }
          if (state is CommentSuccessState) {
            Padding(
              padding:
                  const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              child: SizedBox(
                height: 30,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  primary: false,
                  scrollDirection: Axis.horizontal,
                  itemCount: state.commentModel.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: AppColors.white),
                      child:
                          CommentWidget(commentModel: state.commentModel[index]),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 5,
                    );
                  },
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
