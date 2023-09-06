import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:conduit/bloc/tags_bloc/tags_event.dart';
import 'package:conduit/bloc/tags_bloc/tags_state.dart';
import 'package:conduit/model/all_article_model.dart';
import 'package:conduit/model/all_tags_model.dart';
import 'package:conduit/repository/all_article_repo.dart';

class TagsBloc extends Bloc<TagsEvent, TagsState> {
  AllArticlesRepo repo;
  // int offset = 0;
  // int limit = 10;
  TagsBloc({required this.repo}) : super(TagsInitialState()) {
    on<FetchAllTagsEvent>(_onFetchAllTags);
    on<FetchSearchTagEvent>(_onFetchSearchTag);
  }
  void _onFetchAllTags(FetchAllTagsEvent event, Emitter<TagsState> emit) async {
    try {
      emit(TagsLoadingState());
      dynamic data = await repo.fetchAllTags();
      if (data != null && data is List<String>) {
        emit(TagsSuccessState(allTagsModel: AllTagsModel(tags: data)));
      } else {
        emit(TagsNoTagState());
      }
    } on SocketException {
      emit(TagsNoInternetState());
    } catch (e) {
      print(e.toString());
      emit(TagsErrorState(msg: e.toString()));
    }
  }

  void _onFetchSearchTag(
      FetchSearchTagEvent event, Emitter<TagsState> emit) async {
    try {
      emit(SearchTagLoadingState());
      // offset = 0;
      List<AllArticlesModel> data;
      data = await repo.fetchSearchTags(event.title);
      if (data.isEmpty) {
        emit(SearchNoTagState());
      }
      emit(SearchTagSuccessState(myFavoriteArticleslist: data));
      // offset = offset + 10;
      
    } on SocketException {
      emit(SearchTagNoInternetState());
    } catch (e) {
      print(e.toString());
      emit(SearchTagErrorState(msg: e.toString()));
    }
  }
}
