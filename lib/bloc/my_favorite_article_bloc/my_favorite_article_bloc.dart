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
    on<FetchMyFavoriteArticlesEvent>(_onFetchMyFavoriteArticlesEvent);
    on<FetchNextMyFavoriteArticlesEvent>(_onFetchNextMyFavoriteArticlesEvent);
  }

  _onFetchMyFavoriteArticlesEvent(MyFavoriteArticlesEvent event,
      Emitter<MyFavoriteArticlesState> emit) async {
    try {
      offset = 0;
      emit(MyFavoriteArticlesLoadingState());

      List<AllArticlesModel> aData =
          (await repo.getMyFavoriteArticles(offset, limit))
              .cast<AllArticlesModel>();

      if (aData.isEmpty) {
        emit(NoMyFavoriteArticlesState());
      } else {
        emit(MyFavoriteArticlesLoadedStete(myFavoriteArticleslist: aData));
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
    MyFavoriteArticlesLoadedStete currentState =
        state as MyFavoriteArticlesLoadedStete;
    emit(MyFavoriteArticlesLoadedStete(
        myFavoriteArticleslist: currentState.myFavoriteArticleslist,
        hasReachedMax: false));
    if (currentState is MyFavoriteArticlesLoadedStete) {
      try {
        List<AllArticlesModel> aData =
            (await repo.getMyFavoriteArticles(offset, limit))
                .cast<AllArticlesModel>();
        if (aData.isEmpty) {
          emit(MyFavoriteArticlesLoadedStete(
              myFavoriteArticleslist: currentState.myFavoriteArticleslist,
              hasReachedMax: true));
        } else {
          emit(MyFavoriteArticlesLoadedStete(
            myFavoriteArticleslist: currentState.myFavoriteArticleslist + aData,
          ));
          offset = offset + 10;
        }
      } catch (e) {}
    }
  }
}
// _onFetchMyFavoriteArticlesEvent(MyFavoriteArticlesEvent event,
//       Emitter<MyFavoriteArticlesState> emit) async {
//     try {
//       if (event is FetchNextMyFavoriteArticlesEvent) {
//         print(" The Length is ${event.length!.toInt()}");
//         offset = event.length!.toInt();
//       } else {
//         offset = 0;
//       }
//       if (offset == 0) {
//         emit(MyFavoriteArticlesLoadingState());
//       }

//       List<AllArticlesModel> aData =
//           (await repo.getMyFavoriteArticles(offset, limit))
//               .cast<AllArticlesModel>();
//       if (aData.isEmpty) {
//         emit(NoMyFavoriteArticlesState());
//       } else {
//         bool hasReachedMax = aData.length < 10;
//         if (event is FetchNextMyFavoriteArticlesEvent) {
//           final currentState = state;
//           if (currentState is MyFavoriteArticlesLoadedStete) {
//             aData = [...currentState.myFavoriteArticleslist, ...aData];
//           }
//         }
//         emit(
//           MyFavoriteArticlesLoadedStete(
//               myFavoriteArticleslist: aData, hasReachedMax: hasReachedMax),
//         );
//       }
//     } on SocketException {
//       emit(MyFavoriteArticlesNoInternetState());
//     } catch (e) {
//       print(e);
//       emit(MyFavoriteArticlesErrorState(msg: e.toString()));
//     }
//   }
