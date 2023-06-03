import 'package:conduit/model/new_article_model.dart';
import 'package:equatable/equatable.dart';

abstract class ArticleEvent extends Equatable {}

class SubmitArticleEvent extends ArticleEvent {
  ArticleModel articleModel;
  SubmitArticleEvent({required this.articleModel});
  @override
  List<Object?> get props => [articleModel];
}

class FetchArticleEvent extends ArticleEvent {
  String slug;
  FetchArticleEvent({required this.slug});
  @override
  List<Object?> get props => [slug];
}

class UpdateArticleEvent extends ArticleEvent {
  ArticleModel articleModel;
  String slug;
  UpdateArticleEvent({required this.articleModel, required this.slug});
  @override
  List<Object?> get props => [articleModel, slug];
}

class DeleteArticleEvent extends ArticleEvent {
  String slug;
  DeleteArticleEvent({required this.slug});
  @override
  List<Object?> get props => [slug];
}
