
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

class MyArticlesLoadedState extends MyArticlesState {
  List<AllArticlesModel> myArticleslist;
  bool hasReachedMax;

  MyArticlesLoadedState(
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

class MyArticlesNextDataLoadingState extends MyArticlesState {
  List<Object?> get props => [];
}

class DeleteMyArticleErrorState extends MyArticlesState {
  String msg;
  DeleteMyArticleErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
  @override
  String toString() {
    return msg;
  }
}

class DeleteMyArticleSuccessState extends MyArticlesState {
  @override
  List<Object?> get props => [];
}

class DeleteMyArticleLoadingState extends MyArticlesState {
  @override
  List<Object?> get props => [];
}
