import 'package:conduit/model/new_article_model.dart';
import 'package:equatable/equatable.dart';

abstract class ArticleState extends Equatable {}

// submit article

class ArticleAddSuccessState extends ArticleState {
  String msg;
  ArticleAddSuccessState({required this.msg});
  @override
  List<Object?> get props => [msg];
  @override
  toString() {
    return msg;
  }
}

class ArticleAddErrorState extends ArticleState {
  String msg;
  ArticleAddErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
  @override
  toString() {
    return msg;
  }
}

// fetch article

class ArticleInitialState extends ArticleState {
  @override
  List<Object?> get props => [];
}

class ArticleNoInternetState extends ArticleState {
  @override
  List<Object?> get props => [];
}

class ArticleLoadingState extends ArticleState {
  @override
  List<Object?> get props => [];
}

class NoArticleState extends ArticleState {
  @override
  List<Object?> get props => [];
}

class ArticleLoadedState extends ArticleState {
  List<ArticleModel> articleModel;
  ArticleLoadedState({required this.articleModel});
  @override
  List<Object?> get props => [articleModel];
}

class ArticleErrorState extends ArticleState {
  String msg;
  ArticleErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
  toString() {
    return msg;
  }
}

// update article

class UpdateArticleLoadingState extends ArticleState {
  @override
  List<Object?> get props => [];
}

class UpdateArticleErroeState extends ArticleState {
  String msg;
  UpdateArticleErroeState({required this.msg});
  @override
  List<Object?> get props => [msg];
  @override
  String toString() {
    return msg;
  }
}

class UpdateArticleSuccessState extends ArticleState {
  String msg;
  UpdateArticleSuccessState({required this.msg});
  @override
  List<Object?> get props => [msg];
  @override
  String toString() {
    return msg;
  }
}

// delete article

class ArticleDeleteLoadingState extends ArticleState {
  @override
  List<Object?> get props => [];
}

class ArticleDeleteSuccessState extends ArticleState {
  @override
  List<Object?> get props => [];
}

class ArticleDeleteErrorState extends ArticleState {
  String msg;
  ArticleDeleteErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
  @override
  toString() {
    return msg;
  }
}
