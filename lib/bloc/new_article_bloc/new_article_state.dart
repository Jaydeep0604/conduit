// import 'package:conduit/model/all_artist_model.dart';
// import 'package:conduit/model/new_article_model.dart';
// import 'package:equatable/equatable.dart';

// abstract class NewArticleState extends Equatable {}

// class NewArticleInitialState extends NewArticleState {
//   @override
//   List<Object?> get props => [];
// }

// class NewArticleLoadingState extends NewArticleState {
//   @override
//   List<Object?> get props => [];
// }

// class NewArticleErroeState extends NewArticleState {
//   String msg;
//   NewArticleErroeState({required this.msg});
//   @override
//   List<Object?> get props => [msg];
//   @override
//   String toString() {
//     return msg;
//   }
// }

// class NewArticleSuccessState extends NewArticleState {
//   String msg;
//   NewArticleSuccessState({required this.msg});
//   @override
//   List<Object?> get props => [msg];
//   @override
//   String toString() {
//     return msg;
//   }
// }

// class NoFetchArticleState extends NewArticleState {
//   @override
//   List<Object?> get props => [];
// }

// class FetchArticleLoadingState extends NewArticleState {
//   @override
//   List<Object?> get props => [];
// }

// class FetchArticleErroeState extends NewArticleState {
//   String msg;
//   FetchArticleErroeState({required this.msg});
//   @override
//   List<Object?> get props => [msg];
//   @override
//   String toString() {
//     return msg;
//   }
// }

// class FetchArticleSuccessState extends NewArticleState {
//   // String msg;
//   List<ArticleModel> articleModel;
//   FetchArticleSuccessState({required this.articleModel});
//   @override
//   List<Object?> get props => [articleModel];
//   // @override
//   // String toString() {
//   //   return msg;
//   // }
// }



// class UpdateArticleLoadingState extends NewArticleState {
//   @override
//   List<Object?> get props => [];
// }

// class UpdateArticleErroeState extends NewArticleState {
//   String msg;
//   UpdateArticleErroeState({required this.msg});
//   @override
//   List<Object?> get props => [msg];
//   @override
//   String toString() {
//     return msg;
//   }
// }

// class UpdateArticleSuccessState extends NewArticleState {
//   String msg;
//   UpdateArticleSuccessState({required this.msg});
//   @override
//   List<Object?> get props => [msg];
//   @override
//   String toString() {
//     return msg;
//   }
// }


