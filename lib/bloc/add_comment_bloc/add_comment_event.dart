import 'package:conduit/model/comment_model.dart';
import 'package:equatable/equatable.dart';

abstract class AddCommentEvent extends Equatable {}

class SubmitCommentEvent extends AddCommentEvent {
  AddCommentModel addCommentModel;
  String? slug;
  SubmitCommentEvent({required this.addCommentModel,required this.slug});
  @override
  List<Object?> get props => [addCommentModel,slug];
}
