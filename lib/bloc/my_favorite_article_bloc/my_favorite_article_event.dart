import 'package:equatable/equatable.dart';

abstract class MyFavoriteArticlesEvent extends Equatable {}

class FetchMyFavoriteArticlesEvent extends MyFavoriteArticlesEvent {
  @override
  List<Object?> get props => [];
}

// class FetchNextMyFavoriteArticlesEvent extends MyFavoriteArticlesEvent {
//   int? length;
//   FetchNextMyFavoriteArticlesEvent({required this.length});
//   @override
//   List<Object?> get props => [];
// }
class FetchNextMyFavoriteArticlesEvent extends MyFavoriteArticlesEvent {
  int? length;

  FetchNextMyFavoriteArticlesEvent({required this.length});

  @override
  List<Object?> get props => [length];
}
