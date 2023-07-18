import 'package:equatable/equatable.dart';

abstract class FollowState extends Equatable {}

class FollowInitialState extends FollowState {
  @override
  List<Object?> get props => [];
}

class FollowNoInternetState extends FollowState {
  @override
  List<Object?> get props => [];
}

class FollowLoadingState extends FollowState {
  @override
  List<Object?> get props => [];
}

class FollowSuccessState extends FollowState {
  @override
  List<Object?> get props => [];
}

class UnFollowSuccessState extends FollowState {
  @override
  List<Object?> get props => [];
}

class FollowErrorState extends FollowState {
  String msg;
  FollowErrorState({required this.msg});
  @override
  List<Object?> get props => [this.msg];
  String toString() {
    return msg;
  }
}
