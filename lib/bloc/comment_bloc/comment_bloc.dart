import 'package:bloc/bloc.dart';
import 'package:conduit/bloc/comment_bloc/comment_event.dart';
import 'package:conduit/bloc/comment_bloc/comment_state.dart';
import 'package:conduit/config/shared_preferences_store.dart';
import 'package:conduit/model/comment_model.dart';
import 'package:conduit/repository/all_article_repo.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  AllArticlesRepo repo = AllArticlesImpl();
  CommentBloc() : super(CommentInitialState()) {
    on<fetchCommentEvent>(_onFetchCommentEvent);
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
      // sharedPreferencesStore.logOut();
      emit(
        CommentErrorState(
          msg: e.toString(),
        ),
      );
    }
  }
}
