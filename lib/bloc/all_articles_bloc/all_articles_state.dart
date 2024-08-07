import 'package:conduit/model/all_article_model.dart';

abstract class AllArticlesState {
  late bool hasReachedMax;
}

class AllArticlesInitialState extends AllArticlesState {
  List<Object?> get props => [];
}

class AllArticlesNoInternateState extends AllArticlesState {
  List<Object?> get props => [];
}

class NoAllArticlesState extends AllArticlesState {
  @override
  List<Object?> get props => [];
  @override
  String toString() {
    return "NO User Data Available";
  }
}

class AllArticlesLoadingState extends AllArticlesState {
  List<Object?> get props => [];
}

class AllArticlesLoadedStete extends AllArticlesState {
  List<AllArticlesModel> allArticleslist;
  bool hasReachedMax;

  AllArticlesLoadedStete(
      {this.hasReachedMax = true, required this.allArticleslist});
  @override
  List<Object?> get props => [this.allArticleslist, hasReachedMax];
}

class AllArticlesErrorState extends AllArticlesState {
  final String msg;
  AllArticlesErrorState({required this.msg});
  @override
  List<Object?> get props => [this.msg];
  @override
  String toString() {
    return msg;
  }
}

class AllArticlesUnAuthorizedState extends AllArticlesState {
  List<Object?> get props => [];
}
