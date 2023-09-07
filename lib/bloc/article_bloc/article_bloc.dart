import 'dart:io';

import 'package:conduit/bloc/article_bloc/article_event.dart';
import 'package:conduit/bloc/article_bloc/article_state.dart';
import 'package:conduit/model/new_article_model.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  AllArticlesRepo repo;
  ArticleBloc({required this.repo}) : super(ArticleInitialState()) {
    on<SubmitArticleEvent>(_onSubmitArticleEvent);
    on<FetchArticleEvent>(onFetchArticleEvent);
    on<UpdateArticleEvent>(_onUpdateArticle);
    on<DeleteArticleEvent>(_onDeleteArticleEvent);
  }

  _onSubmitArticleEvent(
      SubmitArticleEvent event, Emitter<ArticleState> emit) async {
    try {
      emit(ArticleLoadingState());
      dynamic data;
      data = await repo.addNewArticle(event.articleModel);
      emit(ArticleAddSuccessState(msg: "New article added successfully"));
    }on SocketException{
      emit(ArticleNoInternetState());
    }
     catch (e) {
      emit(ArticleAddErrorState(msg: e.toString()));
    }
  }

  onFetchArticleEvent(
      FetchArticleEvent event, Emitter<ArticleState> emit) async {
    try {
      emit(ArticleLoadingState());
      List<ArticleModel> data = await repo.getArticle(event.slug);
      if (data.isEmpty) {
        emit(NoArticleState());
      } else {
        emit(ArticleLoadedState(articleModel: data));
      }
    } on SocketException {
      emit(ArticleNoInternetState());
    } catch (e) {
      emit(
        ArticleErrorState(
          msg: e.toString(),
        ),
      );
    }
  }

  _onUpdateArticle(UpdateArticleEvent event, Emitter<ArticleState> emit) async {
    AllArticlesRepo repo = AllArticlesImpl();
    try {
      emit(ArticleLoadingState());
      dynamic data;
      data = await repo.updateArticle(event.articleModel, event.slug);
      emit(UpdateArticleSuccessState(msg: "Article updated successfully"));
    } on SocketException {
      emit(ArticleNoInternetState());
    }  catch (e) {
      emit(UpdateArticleErroeState(msg: e.toString()));
    }
  }

  _onDeleteArticleEvent(
      DeleteArticleEvent event, Emitter<ArticleState> emit) async {
    try {
      dynamic data = await repo.deleteArticle(event.slug);
      if (data == 1) {
        emit(ArticleDeleteSuccessState());
      } else {
        emit(ArticleDeleteErrorState(
            msg: "Something want wrong please try again later"));
      }
    } on SocketException {
      emit(ArticleNoInternetState());
    }  catch (e) {
      emit(
        ArticleDeleteErrorState(
          msg: e.toString(),
        ),
      );
    }
  }
}
