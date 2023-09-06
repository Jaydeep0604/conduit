import 'dart:io';

import 'package:conduit/bloc/my_articles_bloc/my_articles_event.dart';
import 'package:conduit/bloc/my_articles_bloc/my_articles_state.dart';
import 'package:conduit/model/all_article_model.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyArticlesBloc extends Bloc<MyArticlesEvent, MyArticlesState> {
  AllArticlesRepo repo;
  int offset = 0;
  int limit = 10;
  MyArticlesBloc({required this.repo}) : super(MyArticlesInitialState()) {
    on<FetchMyArticlesEvent>(_onMyArticlesEvent);
    on<FetchNextMyArticlesEvent>(_onFetchNextMyArticlesEvent);
    on<DeleteMyArticlesEvent>(_onDeleteMyArticleEvent);
  }

  void _onMyArticlesEvent(
      MyArticlesEvent event, Emitter<MyArticlesState> emit) async {
    try {
      // if (event is FetchNextMyArticlesEvent) {
      //   print(" The Length is ${event.length!.toInt()}");
      //   offset = event.length!.toInt();
      // } else {
      //   offset = 0;
      // }
      // if (offset == 0) {
      offset = 0;
      emit(MyArticlesLoadingState());
      // }
      List<AllArticlesModel> aData =
          (await repo.getMyArticles(offset, limit)).cast<AllArticlesModel>();
      if (aData.isEmpty) {
        emit(NoMyArticlesState());
      } else {
        // bool hasReachedMax = aData.length < 10;
        // if (event is FetchNextMyArticlesEvent) {
        //   final currentState = state;
        //   if (currentState is MyArticlesLoadedStete) {
        //     aData = [...currentState.myArticleslist, ...aData];
        //   }
        // }
        emit(MyArticlesLoadedState(myArticleslist: aData));
        offset = offset + 10;
      }
    } on SocketException {
      emit(MyArticlesNoInternateState());
    } catch (e) {
      print(e);
      emit(MyArticlesErrorState(msg: e.toString()));
    }
  }

  _onFetchNextMyArticlesEvent(
      MyArticlesEvent event, Emitter<MyArticlesState> emit) async {
    MyArticlesLoadedState curentstate = state as MyArticlesLoadedState;
    if (curentstate is MyArticlesLoadedState) {
      try {
        // if (event is FetchNextMyArticlesEvent) {
        //   offset = event.length!.toInt() + 1;
        // }
        // emit(MyArticlesNextDataLoadingState());
        List<AllArticlesModel> myArticleslist =
            (await repo.getMyArticles(offset, limit)).cast<AllArticlesModel>();
        if (myArticleslist.isEmpty) {
          emit(
            MyArticlesLoadedState(
                myArticleslist: curentstate.myArticleslist,
                hasReachedMax: true),
          );
        } else {
          emit(MyArticlesLoadedState(
              myArticleslist: curentstate.myArticleslist + myArticleslist));
          offset = offset + 10;
        }
      } on SocketException {
        emit(MyArticlesNoInternateState());
      } catch (e) {
        emit(MyArticlesLoadedState(
            myArticleslist: curentstate.myArticleslist, hasReachedMax: true));
      }
    }
  }

  _onDeleteMyArticleEvent(
      DeleteMyArticlesEvent event, Emitter<MyArticlesState> emit) async {
    try {
      dynamic data = await repo.deleteArticle(event.slug);
      if (data == 1) {
        emit(DeleteMyArticleSuccessState());
      } else {
        emit(DeleteMyArticleErrorState(
            msg: "Something want wrong please try again later"));
      }
    } on SocketException {
      emit(MyArticlesNoInternateState());
    } catch (e) {
      emit(
        DeleteMyArticleErrorState(
          msg: e.toString(),
        ),
      );
    }
  }
}
