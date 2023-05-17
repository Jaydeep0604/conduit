import 'package:equatable/equatable.dart';

abstract class NewArticleState extends Equatable {}

class NewArticleInitialState extends NewArticleState {
  @override
  List<Object?> get props => [];
}

class NewArticleLoadingState extends NewArticleState {
  @override
  List<Object?> get props => [];
}

class NewArticleErroeState extends NewArticleState {
  String msg;
  NewArticleErroeState({required this.msg});
  @override
  List<Object?> get props => [msg];
  @override
  String toString() {
    return msg;
  }
}

class NewArticleSuccessState extends NewArticleState {
  String msg;
  NewArticleSuccessState({required this.msg});
  @override
  List<Object?> get props => [msg];
  @override
  String toString() {
    return msg;
  }
}
