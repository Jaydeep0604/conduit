import 'package:conduit/model/new_article_model.dart';
import 'package:equatable/equatable.dart';

abstract class NewArticleEvent extends Equatable {}

class SubmitNewArticle extends NewArticleEvent {
  NewArticleModel newArticleModel;
  SubmitNewArticle({required this.newArticleModel});
  @override
  List<Object?> get props => [newArticleModel];
}
