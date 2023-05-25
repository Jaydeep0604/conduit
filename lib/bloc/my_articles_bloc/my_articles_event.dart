import 'package:equatable/equatable.dart';

  abstract class MyArticlesEvent extends Equatable {}

  class FetchMyArticlesEvent extends MyArticlesEvent {
    @override
    List<Object?> get props => [];
  }

  // class FetchNextMyArticlesEvent extends MyArticlesEvent {
  //   int? length;
  //   FetchNextMyArticlesEvent({required this.length});
  //   @override
  //   List<Object?> get props => [];
  // }
  class FetchNextMyArticlesEvent extends MyArticlesEvent {
  int? length;

  FetchNextMyArticlesEvent({required this.length});

  @override
  List<Object?> get props => [length];
}

