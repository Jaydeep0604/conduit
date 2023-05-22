import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {}

class fetchCommentEvent extends CommentEvent {
  @override
  List<Object?> get props => [];
}

class deleteCommentEvent extends CommentEvent {
  final int commentId;

  deleteCommentEvent(this.commentId);

  @override
  List<Object?> get props => [commentId];
}

