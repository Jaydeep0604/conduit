import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:conduit/bloc/feed_bloc/feed_event.dart';
import 'package:conduit/bloc/feed_bloc/feed_state.dart';
import 'package:conduit/model/all_article_model.dart';
import 'package:conduit/repository/all_article_repo.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  AllArticlesRepo repo;
  int offset = 0;
  final int limit = 10;
  FeedBloc({required this.repo}) : super(FeedInitialState()) {
    on<FetchFeedEvent>(onFetchFeedEvent);
    on<FetchNextFeedEvent>(onFetchNextFeedEvent);
  }
  onFetchFeedEvent(FetchFeedEvent event, Emitter<FeedState> emit) async {
    try {
      offset = 0;
      emit(FeedLoadingState());
      List<AllArticlesModel> aData =
          (await repo.getYourFeedData(offset: offset, limit: limit))
              .cast<AllArticlesModel>();
      if (aData.isEmpty) {
        emit(NoFeedState());
      } else {
        emit(FeedLoadedState(allArticleslist: aData));
        offset = offset + 10;
      }
    } on SocketException {
      emit(FeedNoInternetState());
    } catch (e) {
      print(e.toString());
      emit(
        FeedErrorState(msg: e.toString()),
      );
    }
  }

  onFetchNextFeedEvent(
      FetchNextFeedEvent event, Emitter<FeedState> emit) async {
    FeedLoadedState curentstate = state as FeedLoadedState;
    emit(FeedLoadedState(
        allArticleslist: curentstate.allArticleslist, hasReachedMax: false));
    if (curentstate is FeedLoadedState) {
      try {
        List<AllArticlesModel> myArticleslist =
            (await repo.getYourFeedData(offset: offset, limit: limit))
                .cast<AllArticlesModel>();
        if (myArticleslist.isEmpty) {
          emit(
            FeedLoadedState(
                allArticleslist: curentstate.allArticleslist,
                hasReachedMax: true),
          );
        } else {
          emit(FeedLoadedState(
              allArticleslist: curentstate.allArticleslist + myArticleslist));
          offset = offset + 10;
        }
      } on SocketException {
        emit(FeedNoInternetState());
      } catch (e) {
        emit(FeedLoadedState(
            allArticleslist: curentstate.allArticleslist, hasReachedMax: true));
      }
    }
  }
}
