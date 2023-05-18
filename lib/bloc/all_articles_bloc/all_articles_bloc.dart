import 'package:bloc/bloc.dart';
import 'package:conduit/model/all_artist_model.dart';
import 'package:conduit/repository/all_article_repo.dart';

import 'all_articles_event.dart';
import 'all_articles_state.dart';

class AllArticlesBloc extends Bloc<AllArticlesEvent, AllArticlesState> {
  AllArticlesRepo repo;

  AllArticlesBloc({required this.repo}) : super(AllArticlesInitialState()) {
    on<AllArticlesEvent>(_onAllArticlesEvent);
  }
  _onAllArticlesEvent(AllArticlesEvent event, Emitter<AllArticlesState> emit) async {
    try {
      emit(AllArticlesLoadingState());
      List<AllArticlesModel> aData = (await repo.getAllArticlesData()).cast<AllArticlesModel>();

      if (aData.isEmpty) {
        emit(NoAllArticlesState());
      } else {
        emit(AllArticlesLoadedStete(allArticleslist: aData));
      }
    } catch (e) {
      print(e);
      emit(AllArticlesErrorState(msg: e.toString()));
    }
  }
}