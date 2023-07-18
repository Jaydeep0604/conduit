import 'package:equatable/equatable.dart';

abstract class LikeEvent extends Equatable {}

class LikeArticleEvent extends LikeEvent {
  final String slug;
  @override
  LikeArticleEvent({required this.slug});
  @override
  List<Object?> get props => [this.slug];
}

class RemoveLikeArticleEvent extends LikeEvent {
  final String slug;
  @override
  RemoveLikeArticleEvent({required this.slug});
  @override
  List<Object?> get props => [this.slug];
}
