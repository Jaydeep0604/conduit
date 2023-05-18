import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {}

class fetchCommentEvent extends CommentEvent {
  @override
  List<Object?> get props => [];
}
