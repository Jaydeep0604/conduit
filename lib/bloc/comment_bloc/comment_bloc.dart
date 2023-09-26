import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:conduit/bloc/comment_bloc/comment_event.dart';
import 'package:conduit/bloc/comment_bloc/comment_state.dart';
import 'package:conduit/model/comment_model.dart';
import 'package:conduit/repository/all_article_repo.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  AllArticlesRepo repo;
  CommentBloc({required this.repo}) : super(CommentInitialState()) {
    on<fetchCommentEvent>(_onFetchCommentEvent);
    on<deleteCommentEvent>(_onDeleteCommentEvent);
  }
  _onFetchCommentEvent(
      fetchCommentEvent event, Emitter<CommentState> emit) async {
    try {
      emit(CommentLoadingState());
      List<CommentModel> data = await repo.getComment(event.slug);
      if (data.isEmpty) {
        emit(NoCommentState());
      } else {
        emit(CommentSuccessState(commentModel: data));
      }
    } on SocketException {
      emit(CommentNoInternetState());
    } catch (e) {
      emit(
        CommentErrorState(
          msg: e.toString(),
        ),
      );
    }
  }

  _onDeleteCommentEvent(
      deleteCommentEvent event, Emitter<CommentState> emit) async {
    try {
      emit(CommentDeleteLoadingState());
      dynamic data = await repo.deleteComment(event.commentId, event.slug);
      if (data == 1) {
        emit(DeleteCommentSuccessState());
      } else {
        emit(DeleteCommentErrorState(
            msg: "Something want wrong please try again later"));
      }
    } on SocketException {
      emit(CommentNoInternetState());
    } catch (e) {
      emit(
        CommentErrorState(
          msg: e.toString(),
        ),
      );
    }
  }
}
