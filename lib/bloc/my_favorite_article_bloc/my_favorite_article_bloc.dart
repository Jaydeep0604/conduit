import 'dart:io';

import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_event.dart';
import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_state.dart';
import 'package:conduit/model/all_article_model.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFavoriteArticlesBloc
    extends Bloc<MyFavoriteArticlesEvent, MyFavoriteArticlesState> {
  AllArticlesRepo repo;
  int offset = 0;
  int limit = 10;
  MyFavoriteArticlesBloc({required this.repo})
      : super(MyFavoriteArticlesInitialState()) {
    on<FetchMyFavoriteArticlesEvent>(_onMyFavoriteArticlesEvent);
    on<FetchNextMyFavoriteArticlesEvent>(_onFetchNextMyFavoriteArticlesEvent);
  }

  void _onMyFavoriteArticlesEvent(MyFavoriteArticlesEvent event,
      Emitter<MyFavoriteArticlesState> emit) async {
    try {
      // if (event is FetchNextMyFavoriteArticlesEvent) {
      //   print(" The Length is ${event.length!.toInt()}");
      //   offset = event.length!.toInt();
      // } else {
      //   offset = 0;
      // }
      // if (offset == 0) {
      // }
      offset = 0;
      emit(MyFavoriteArticlesLoadingState());

      List<AllArticlesModel> aData =
          (await repo.getMyFavoriteArticles(offset, limit))
              .cast<AllArticlesModel>();
      if (aData.isEmpty) {
        emit(NoMyFavoriteArticlesState());
      } else {
        // bool hasReachedMax = aData.length < 10;
        // if (event is FetchNextMyFavoriteArticlesEvent) {
        //   final currentState = state;
        //   if (currentState is MyFavoriteArticlesLoadedStete) {
        //     aData = [...currentState.myFavoriteArticleslist, ...aData];
        //   }
        // }
        emit(
          MyFavoriteArticlesLoadedStete(myFavoriteArticleslist: aData),
        );
        offset = offset + 10;
      }
    } on SocketException {
      emit(MyFavoriteArticlesNoInternetState());
    } catch (e) {
      print(e);
      emit(MyFavoriteArticlesErrorState(msg: e.toString()));
    }
  }

  _onFetchNextMyFavoriteArticlesEvent(FetchNextMyFavoriteArticlesEvent event,
      Emitter<MyFavoriteArticlesState> emit) async {
    MyFavoriteArticlesLoadedStete curentstate =
        state as MyFavoriteArticlesLoadedStete;
    if (curentstate is MyFavoriteArticlesLoadedStete) {
      try {
        List<AllArticlesModel> myFavoriteArticleslist =
            (await repo.getMyFavoriteArticles(offset, limit))
                .cast<AllArticlesModel>();
        if (myFavoriteArticleslist.isEmpty) {
          emit(
            MyFavoriteArticlesLoadedStete(
                myFavoriteArticleslist: curentstate.myFavoriteArticleslist,
                hasReachedMax: true),
          );
        } else {
          emit(MyFavoriteArticlesLoadedStete(
              myFavoriteArticleslist:
                  curentstate.myFavoriteArticleslist + myFavoriteArticleslist));
          offset = offset + 1;
        }
      } on SocketException {
      emit(MyFavoriteArticlesNoInternetState());
    }  catch (e) {
        emit(MyFavoriteArticlesLoadedStete(
            myFavoriteArticleslist: curentstate.myFavoriteArticleslist,
            hasReachedMax: true));
      }
    }
  }
}
