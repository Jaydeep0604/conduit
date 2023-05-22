import 'package:conduit/model/comment_model.dart';
import 'package:equatable/equatable.dart';

abstract class AddCommentEvent extends Equatable {}

class SubmitCommentEvent extends AddCommentEvent {
  AddCommentModel addCommentModel;
  SubmitCommentEvent({required this.addCommentModel});
  @override
  List<Object?> get props => [addCommentModel];
}
