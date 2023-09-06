import 'dart:io';

import 'package:conduit/bloc/add_comment_bloc/add_comment_event.dart';
import 'package:conduit/bloc/add_comment_bloc/add_comment_state.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCommentBloc extends Bloc<AddCommentEvent, AddCommentState> {
  AddCommentBloc() : super(AddCommentInitialState()) {
    on<SubmitCommentEvent>(_onSubmitCommentEvent);
  }
  _onSubmitCommentEvent(
      SubmitCommentEvent event, Emitter<AddCommentState> emit) async {
    AllArticlesRepo repo = AllArticlesImpl();
    try {
      emit(AddCommentLoadingState());
      // ignore: unused_local_variable
      dynamic data = await repo.addComment(event.addCommentModel, event.slug!);
      emit(AddCommentSuccessState(msg: "New article added successfully"));
    } on SocketException {
      emit(AddCommentNoInternetState());
    } catch (e) {
      emit(AddCommentErroeState(msg: e.toString()));
    }
  }
}
