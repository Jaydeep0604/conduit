import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_event.dart';
import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_state.dart';
import 'package:conduit/model/all_artist_model.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFavoriteArticlesBloc
    extends Bloc<MyFavoriteArticlesEvent, MyFavoriteArticlesState> {
  AllArticlesRepo repo;
  int offset = 1;
  int limit = 10;
  MyFavoriteArticlesBloc({required this.repo})
      : super(MyFavoriteArticlesInitialState()) {
    on<MyFavoriteArticlesEvent>(_onMyFavoriteArticlesEvent);
    // on<FetchNextMyFavoriteArticlesEvent>(_onFetchNextMyFavoriteArticlesEvent);
  }

  void _onMyFavoriteArticlesEvent(MyFavoriteArticlesEvent event,
      Emitter<MyFavoriteArticlesState> emit) async {
    try {
      if (event is FetchNextMyFavoriteArticlesEvent) {
        print(" The Length is ${event.length!.toInt()}");
        offset = event.length!.toInt();
      } else {
        offset = 0;
      }
      if (offset == 0) {
        emit(MyFavoriteArticlesLoadingState());
      }

      List<AllArticlesModel> aData =
          (await repo.getMyFavoriteArticles(offset, limit))
              .cast<AllArticlesModel>();
      if (aData.isEmpty) {
        emit(NoMyFavoriteArticlesState());
      } else {
        bool hasReachedMax = aData.length < 10;
        if (event is FetchNextMyFavoriteArticlesEvent) {
          final currentState = state;
          if (currentState is MyFavoriteArticlesLoadedStete) {
            aData = [...currentState.myFavoriteArticleslist, ...aData];
          }
        }
        emit(
          MyFavoriteArticlesLoadedStete(
              myFavoriteArticleslist: aData, hasReachedMax: hasReachedMax),
        );
      }
    } catch (e) {
      print(e);
      emit(MyFavoriteArticlesErrorState(msg: e.toString()));
    }
  }
}
