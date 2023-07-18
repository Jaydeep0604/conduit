import 'package:conduit/model/all_artist_model.dart';
import 'package:equatable/equatable.dart';

abstract class LikeState extends Equatable {}

class LikeInitialState extends LikeState {
  @override
  List<Object?> get props => [];
}
class LikeNoInternetState extends LikeState {
  @override
  List<Object?> get props => [];
}

class LikeLoadingState extends LikeState {
  @override
  List<Object?> get props => [];
}

class LikeSuccessState extends LikeState {
  final String msg;
  LikeSuccessState({required this.msg});
  @override
  List<Object?> get props => [this.msg];
}

class RemoveLikeSuccessState extends LikeState {
  final String msg;
  RemoveLikeSuccessState({required this.msg});
  @override
  List<Object?> get props => [this.msg];
  @override
  String toString(){
    return msg;
  }
}
class LikeErroeState extends LikeState {
  final String msg;
  LikeErroeState({required this.msg});
  @override
  List<Object?> get props => [this.msg];
  String toString(){
    return msg;
  }
}