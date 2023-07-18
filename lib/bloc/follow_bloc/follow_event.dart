import 'package:equatable/equatable.dart';

abstract class FollowEvent extends Equatable {}

class FollowUserEvent extends FollowEvent {
  String? username;
  FollowUserEvent({required this.username});
  @override
  List<Object?> get props => [this.username];
}

class UnFollowUserEvent extends FollowEvent {
  String? username;
  UnFollowUserEvent({required this.username});
  @override
  List<Object?> get props => [this.username];
}
