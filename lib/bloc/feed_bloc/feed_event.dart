import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {}

class FetchFeedEvent extends FeedEvent {
  @override
  List<Object?> get props => [];
}
class FetchNextFeedEvent extends FeedEvent {
  @override
  List<Object?> get props => [];
}