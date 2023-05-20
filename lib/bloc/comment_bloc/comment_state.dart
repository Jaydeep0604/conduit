import 'package:conduit/model/comment_model.dart';
import 'package:equatable/equatable.dart';

abstract class CommentState extends Equatable {}

class CommentInitialState extends CommentState {
  @override
  List<Object?> get props => [];
}

class CommentLoadingState extends CommentState {
  @override
  List<Object?> get props => [];
}

class CommentLoadedState extends CommentState {
  @override
  List<Object?> get props => [];
}

class NoCommentState extends CommentState {
  @override
  List<Object?> get props => [];
}

class CommentSuccessState extends CommentState {
  List<CommentModel> commentModel;
  bool hasReachedMax;
  CommentSuccessState({this.hasReachedMax = true, required this.commentModel});
  @override
  List<Object?> get props => [
        this.commentModel,
      ];
  // String toString() {
  //   return msg;
  // }
}

class CommentErrorState extends CommentState {
  String msg;
  CommentErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
  @override
  String toString() {
    return msg;
  }
}
