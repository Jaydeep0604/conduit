
import 'package:conduit/model/all_artist_model.dart';

abstract class MyArticlesState {
  late bool hasReachedMax;
}

class MyArticlesInitialState extends MyArticlesState {
  List<Object?> get props => [];
}

class MyArticlesNoInternateState extends MyArticlesState {
  List<Object?> get props => [];
}

class MyArticlesLoadingState extends MyArticlesState {
  List<Object?> get props => [];
}
class MyArticlesNextDataLoadingState extends MyArticlesState {
  List<Object?> get props => [];
}

class MyArticlesLoadedStete extends MyArticlesState {
  List<AllArticlesModel> myArticleslist;
  bool hasReachedMax;

  MyArticlesLoadedStete(
      {this.hasReachedMax = true, required this.myArticleslist});
  @override
  List<Object?> get props => [this.myArticleslist, hasReachedMax];
}

class NoMyArticlesState extends MyArticlesState {
  @override
  List<Object?> get props => [];
  @override
  String toString() {
    return "NO User Data Available";
  }
}

class MyArticlesErrorState extends MyArticlesState {
  final String msg;
  MyArticlesErrorState({required this.msg});
  @override
  List<Object?> get props => [this.msg];
  @override
  String toString() {
    return msg;
  }
}
