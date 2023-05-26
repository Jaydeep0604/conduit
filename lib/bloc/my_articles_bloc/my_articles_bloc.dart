import 'package:conduit/bloc/my_articles_bloc/my_articles_event.dart';
import 'package:conduit/bloc/my_articles_bloc/my_articles_state.dart';
import 'package:conduit/model/all_artist_model.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyArticlesBloc extends Bloc<MyArticlesEvent, MyArticlesState> {
  AllArticlesRepo repo;
  int offset = 1;
  int limit = 10;
  MyArticlesBloc({required this.repo}) : super(MyArticlesInitialState()) {
    on<MyArticlesEvent>(_onMyArticlesEvent);
    // on<FetchNextMyArticlesEvent>(_onFetchNextMyArticlesEvent);
  }

  void _onMyArticlesEvent(
      MyArticlesEvent event, Emitter<MyArticlesState> emit) async {
    try {
      if (event is FetchNextMyArticlesEvent) {
        print(" The Length is ${event.length!.toInt()}");
        offset = event.length!.toInt();
      } else {
        offset = 0;
      }
      if (offset == 0) {
        emit(MyArticlesLoadingState());
      }

      List<AllArticlesModel> aData =
          (await repo.getMyArticles(offset, limit)).cast<AllArticlesModel>();
      if (aData.isEmpty) {
        emit(NoMyArticlesState());
      } else {
        bool hasReachedMax = aData.length < 10;
        if (event is FetchNextMyArticlesEvent) {
          final currentState = state;
          if (currentState is MyArticlesLoadedStete) {
            aData = [...currentState.myArticleslist, ...aData];
          }
        }
        emit(
          MyArticlesLoadedStete(
              myArticleslist: aData, hasReachedMax: hasReachedMax),
        );
      }
    } catch (e) {
      print(e);
      emit(MyArticlesErrorState(msg: e.toString()));
    }
  }

  // _onFetchNextMyArticlesEvent(
  //     MyArticlesEvent event, Emitter<MyArticlesState> emit) async {
  //   MyArticlesLoadedStete curentstate = state as MyArticlesLoadedStete;
  //   if (curentstate is MyArticlesLoadedStete) {
  //     try {
  //       emit(MyArticlesNextDataLoadingState());
  //       if (event is FetchNextMyArticlesEvent) {
  //         print(" The Length is ${event.length!.toInt()}");
  //         offset = event.length!.toInt();
  //       } else {
  //         offset = 0;
  //       }
  //       List<AllArticlesModel> aData =
  //           (await repo.getMyArticles(offset, limit)).cast<AllArticlesModel>();
  //       if (aData.isEmpty) {
  //         emit(NoMyArticlesState());
  //       } else {
  //         bool hasReachedMax = aData.length < 10;
  //         if (event is FetchNextMyArticlesEvent) {
  //           final currentState = state;
  //           if (currentState is MyArticlesLoadedStete) {
  //             aData = [...currentState.myArticleslist, ...aData];
  //           }
  //         }
  //         emit(
  //           MyArticlesLoadedStete(
  //             myArticleslist: aData,
  //           ),
  //         );
  //       }
  //     } catch (e) {
  //       emit(MyArticlesLoadedStete(
  //           myArticleslist: curentstate.myArticleslist, hasReachedMax: true));
  //     }
  //   }
  // }
}
