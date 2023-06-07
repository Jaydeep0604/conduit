import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {}

class fetchCommentEvent extends CommentEvent {
  String slug;
  fetchCommentEvent({required this.slug});
  @override
  List<Object?> get props => [slug];
}

class deleteCommentEvent extends CommentEvent {
  final int commentId;
  final String slug;
  deleteCommentEvent({required this.commentId, required this.slug});

  @override
  List<Object?> get props => [commentId, slug];
}
