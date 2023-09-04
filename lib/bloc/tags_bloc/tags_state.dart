import 'package:conduit/model/all_artist_model.dart';
import 'package:conduit/model/all_tags_model.dart';
import 'package:equatable/equatable.dart';

abstract class TagsState extends Equatable {}

// all tags

class TagsInitialState extends TagsState {
  @override
  List<Object?> get props => [];
}

class TagsLoadingState extends TagsState {
  @override
  List<Object?> get props => [];
}

class TagsNoInternetState extends TagsState {
  @override
  List<Object?> get props => [];
}

class TagsNoTagState extends TagsState {
  @override
  List<Object?> get props => [];
}

class TagsErrorState extends TagsState {
  String msg;
  TagsErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
}

class TagsSuccessState extends TagsState {
  AllTagsModel allTagsModel;

  TagsSuccessState({required this.allTagsModel});
  @override
  List<Object?> get props => [allTagsModel];
}

// search tag

class SearchTagLoadingState extends TagsState {
  @override
  List<Object?> get props => [];
}

class SearchTagNoInternetState extends TagsState {
  @override
  List<Object?> get props => [];
}

class SearchNoTagState extends TagsState {
  @override
  List<Object?> get props => [];
}

class SearchTagErrorState extends TagsState {
  String msg;
  SearchTagErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
}

class SearchTagSuccessState extends TagsState {
  List<AllArticlesModel> myFavoriteArticleslist;
  bool? hasReachedMax;
  SearchTagSuccessState(
      {required this.myFavoriteArticleslist, this.hasReachedMax});
  @override
  List<Object?> get props => [myFavoriteArticleslist,hasReachedMax];
}
