import 'package:conduit/bloc/new_article_bloc/new_article_event.dart';
import 'package:conduit/bloc/new_article_bloc/new_article_state.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewArticleBloc extends Bloc<NewArticleEvent, NewArticleState> {
  NewArticleBloc() : super(NewArticleInitialState()) {
    on<SubmitNewArticle>(_onSubmitNewArticle);
  }
  _onSubmitNewArticle(
      SubmitNewArticle event, Emitter<NewArticleState> emitt) async {
    AllArticlesRepo repo = AllArticlesImpl();
    try {
      emit(NewArticleLoadingState());
      dynamic data;
      data = await repo.addNewArticle(event.newArticleModel);
      emit(NewArticleSuccessState(msg: "New article added successfully"));
    } catch (e) {
      emit(NewArticleErroeState(msg: e.toString()));
    }
  }
}
