import 'package:conduit/model/comment_model.dart';
import 'package:equatable/equatable.dart';

abstract class AddCommentEvent extends Equatable {}

class SubmitCommentEvent extends AddCommentEvent {
  CommentModel commentModel;
  SubmitCommentEvent({required this.commentModel});
  @override
  List<Object?> get props => [commentModel];
}
