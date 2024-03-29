import 'package:equatable/equatable.dart';

abstract class MyArticlesEvent extends Equatable {}

class FetchMyArticlesEvent extends MyArticlesEvent {
  @override
  List<Object?> get props => [];
}

class DeleteMyArticlesEvent extends MyArticlesEvent {
  String slug;
  DeleteMyArticlesEvent({required this.slug});
  @override
  List<Object?> get props => [slug];
}

class FetchNextMyArticlesEvent extends MyArticlesEvent {
  @override
  List<Object?> get props => [];
}
