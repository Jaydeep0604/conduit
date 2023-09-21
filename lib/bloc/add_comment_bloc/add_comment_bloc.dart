import 'dart:io';

import 'package:conduit/bloc/add_comment_bloc/add_comment_event.dart';
import 'package:conduit/bloc/add_comment_bloc/add_comment_state.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCommentBloc extends Bloc<AddCommentEvent, AddCommentState> {
  AllArticlesRepo repo = AllArticlesImpl();
  AddCommentBloc({required this.repo}) : super(AddCommentInitialState()) {
    on<SubmitCommentEvent>(_onSubmitCommentEvent);
  }
  _onSubmitCommentEvent(
      SubmitCommentEvent event, Emitter<AddCommentState> emit) async {
    try {
      emit(AddCommentLoadingState());
      // ignore: unused_local_variable
      dynamic data = await repo.addComment(event.addCommentModel, event.slug!);
      if (data.toString().contains("OK")) {
        emit(AddCommentSuccessState());
      } else {
        emit(AddCommentErroeState(msg: data.toString()));
      }
    } on SocketException {
      emit(AddCommentNoInternetState());
    } catch (e) {
      emit(AddCommentErroeState(msg: e.toString()));
    }
  }
}
