import 'package:equatable/equatable.dart';

abstract class AddCommentState extends Equatable {}

class AddCommentInitialState extends AddCommentState {
  
  @override
  List<Object?> get props => [];
}

class AddCommentNoInternetState extends AddCommentState {
  @override
  List<Object?> get props => [];
}

class AddCommentLoadingState extends AddCommentState {
  @override
  List<Object?> get props => [];
}

class AddCommentErroeState extends AddCommentState {
  String msg;
  AddCommentErroeState({required this.msg});
  @override
  List<Object?> get props => [msg];
  @override
  String toString() {
    return msg;
  }
}

class AddCommentSuccessState extends AddCommentState {
  
  @override
  List<Object?> get props => [];
}
