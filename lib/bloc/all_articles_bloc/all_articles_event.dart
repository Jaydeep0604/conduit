import 'package:equatable/equatable.dart';

abstract class AllArticlesEvent extends Equatable {}

class FetchAllArticlesEvent extends AllArticlesEvent {
  @override
  List<Object?> get props => [];
}

class FetchNextAllArticlesEvent extends AllArticlesEvent {
  int? length;
  FetchNextAllArticlesEvent({required this.length});
  @override
  List<Object?> get props => [];
}
