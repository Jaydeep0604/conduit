import 'package:bloc/bloc.dart';
import 'package:conduit/bloc/comment_bloc/comment_event.dart';
import 'package:conduit/bloc/comment_bloc/comment_state.dart';
import 'package:conduit/config/shared_preferences_store.dart';
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
      List<CommentModel> data = await repo.getComment();
      if (data.isEmpty) {
        emit(NoCommentState());
      } else {
        // sharedPreferencesStore.logOut();
        emit(CommentSuccessState(commentModel: data));
      }
    } catch (e) {
      sharedPreferencesStore.removeSlug();
      emit(
        CommentErrorState(
          msg: e.toString(),
        ),
      );
    }
  }

  _onDeleteCommentEvent(deleteCommentEvent event, Emitter<CommentState> emit) async {
  try {
    emit(CommentLoadingState());
    dynamic data = await repo.deleteComment(event.commentId);
    if (data == 1) {
      emit(DeleteCommentSuccessState());
    } else {
      emit(DeleteCommentErrorState(msg: "Something want wrong please try again later"));
    }
  } catch (e) {
    emit(
      CommentErrorState(
        msg: e.toString(),
      ),
    );
  }
}

}
