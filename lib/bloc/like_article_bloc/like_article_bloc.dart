import 'dart:io';

import 'package:conduit/bloc/like_article_bloc/like_article_event.dart';
import 'package:conduit/bloc/like_article_bloc/like_article_state.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  AllArticlesRepo repo;
  LikeBloc({required this.repo}) : super(LikeInitialState()) {
    on<LikeArticleEvent>(_onLikeArtice);
    on<RemoveLikeArticleEvent>(_onRemoveLikeArticle);
  }
  _onLikeArtice(LikeArticleEvent event, Emitter<LikeState> emit) async {
    try {
      emit(LikeLoadingState());
      dynamic data = await repo.likeArticle(event.slug);
      if (data == true) {
        print("Item added successfully in favourite list");
        emit(LikeSuccessState(msg: "Item added successfully in favourite list"));
      }
    } on SocketException {
      emit(LikeNoInternetState());
    } catch (e) {
      print(e.toString());
      emit(
        LikeErroeState(msg: e.toString()),
      );
    }
  }

  _onRemoveLikeArticle(
      RemoveLikeArticleEvent event, Emitter<LikeState> emit) async {
    try {
      emit(LikeLoadingState());
      dynamic data = await repo.removeLikeArticle(event.slug);
      if (data == true) {
        print("Item removed successfully in favourite list");
        emit(RemoveLikeSuccessState(
            msg: "Item removed successfully in favourite list"));
      }
    } on SocketException {
      emit(LikeNoInternetState());
    } catch (e) {
      print(e.toString());
      emit(
        LikeErroeState(msg: e.toString()),
      );
    }
  }
}
