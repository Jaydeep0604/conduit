import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:conduit/bloc/follow_bloc/follow_event.dart';
import 'package:conduit/bloc/follow_bloc/follow_state.dart';
import 'package:conduit/repository/all_article_repo.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  AllArticlesRepo repo;
  FollowBloc({required this.repo}) : super(FollowInitialState()) {
    on<FollowUserEvent>(_onFollowUser);
    on<UnFollowUserEvent>(_onUnFollowUser);
  }

  _onFollowUser(FollowUserEvent event, Emitter<FollowState> emit) async {
    try {
      emit(FollowLoadingState());
      dynamic data = await repo.followUser(event.username!);
      if (data == true) {
        emit(FollowSuccessState());
      } else {
        emit(FollowErrorState(
            msg: "Something want wrong please try again later"));
      }
    } on SocketException {
      emit(FollowNoInternetState());
    } catch (e) {
      print(e.toString());
      emit(FollowErrorState(msg: e.toString()));
    }
  }

  _onUnFollowUser(UnFollowUserEvent event, Emitter<FollowState> emit) async {
    try {
      emit(FollowLoadingState());
      dynamic data = await repo.unFollowUser(event.username!);
      if (data == true) {
        emit(UnFollowSuccessState());
      } else {
        emit(FollowErrorState(
            msg: "Something want wrong please try again later"));
      }
    } on SocketException {
      emit(FollowNoInternetState());
    } catch (e) {
      print(e.toString());
      emit(FollowErrorState(msg: e.toString()));
    }
  }
}
