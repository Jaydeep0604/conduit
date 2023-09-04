import 'package:equatable/equatable.dart';

abstract class TagsEvent extends Equatable {}

class FetchAllTagsEvent extends TagsEvent {
  @override
  List<Object?> get props => [];
}

class FetchSearchTagEvent extends TagsEvent {
  String title;
  FetchSearchTagEvent({required this.title});
  @override
  List<Object?> get props => [title];
}

class FetchSearchMoreTagEvent extends TagsEvent {
  int? length;
  FetchSearchMoreTagEvent({required this.length});
  @override
  List<Object?> get props => [length];
}
