import 'package:conduit/model/all_article_model.dart';

abstract class FeedState {
}

class FeedInitialState extends FeedState {
  List<Object?> get props => [];
}

class FeedNoInternetState extends FeedState {
  List<Object?> get props => [];
}

class FeedLoadingState extends FeedState {
  List<Object?> get props => [];
}

class NoFeedState extends FeedState {
  List<Object?> get props => [];
}

class FeedLoadedState extends FeedState {
  List<AllArticlesModel> allArticleslist;
  bool hasReachedMax;
  FeedLoadedState({required this.allArticleslist, this.hasReachedMax = true});
  @override
  List<Object?> get props => [allArticleslist,hasReachedMax];
}

class FeedErrorState extends FeedState {
  String? msg;
  FeedErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
}
