import 'package:conduit/model/all_article_model.dart';

abstract class MyFavoriteArticlesState {
  late bool hasReachedMax;
}

class MyFavoriteArticlesInitialState extends MyFavoriteArticlesState {
  List<Object?> get props => [];
}

class MyFavoriteArticlesNoInternetState extends MyFavoriteArticlesState {
  List<Object?> get props => [];
}


class MyFavoriteArticlesLoadingState extends MyFavoriteArticlesState {
  List<Object?> get props => [];
}

class MyFavoriteArticlesNextDataLoadingState extends MyFavoriteArticlesState {
  List<Object?> get props => [];
}

class NoMyFavoriteArticlesState extends MyFavoriteArticlesState {
  @override
  List<Object?> get props => [];
  @override
  String toString() {
    return "NO User Data Available";
  }
}

class MyFavoriteArticlesLoadedStete extends MyFavoriteArticlesState {
  List<AllArticlesModel> myFavoriteArticleslist;
  bool hasReachedMax;

  MyFavoriteArticlesLoadedStete(
      {this.hasReachedMax = true, required this.myFavoriteArticleslist});
  @override
  List<Object?> get props => [this.myFavoriteArticleslist, hasReachedMax];
}


class MyFavoriteArticlesErrorState extends MyFavoriteArticlesState {
  final String msg;
  MyFavoriteArticlesErrorState({required this.msg});
  @override
  List<Object?> get props => [this.msg];
  @override
  String toString() {
    return msg;
  }
}
