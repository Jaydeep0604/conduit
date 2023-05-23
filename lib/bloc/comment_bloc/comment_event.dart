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

  deleteCommentEvent(this.commentId);

  @override
  List<Object?> get props => [commentId];
}
