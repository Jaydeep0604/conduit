// import 'package:conduit/bloc/new_article_bloc/new_article_event.dart';
// import 'package:conduit/bloc/new_article_bloc/new_article_state.dart';
// import 'package:conduit/model/new_article_model.dart';
// import 'package:conduit/repository/all_article_repo.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class NewArticleBloc extends Bloc<NewArticleEvent, NewArticleState> {
//   AllArticlesRepo repo = AllArticlesImpl();
//   NewArticleBloc() : super(NewArticleInitialState()) {
//     on<SubmitNewArticle>(_onSubmitNewArticle);
//     on<FetchArticle>(_onFetchArticle);
//     on<UpdateArticle>(_onUpdateArticle);
//   }
//   _onSubmitNewArticle(
//       SubmitNewArticle event, Emitter<NewArticleState> emitt) async {
//     try {
//       emit(NewArticleLoadingState());
//       dynamic data;
//       data = await repo.addNewArticle(event.newArticleModel);
//       emit(NewArticleSuccessState(msg: "New article added successfully"));
//     } catch (e) {
//       emit(NewArticleErroeState(msg: e.toString()));
//     }
//   }

//   _onFetchArticle(FetchArticle event, Emitter<NewArticleState> emit) async {
//     try {
//       emit(FetchArticleLoadingState());
//       List<ArticleModel> data = await repo.getArticle(event.slug);
//       if (data.isEmpty) {
//         emit(NoFetchArticleState());
//       } else {
//         emit(FetchArticleSuccessState(articleModel: data));
//       }
//     } catch (e) {
//       emit(
//         FetchArticleErroeState(
//           msg: e.toString(),
//         ),
//       );
//     }
//   }

//   _onUpdateArticle(UpdateArticle event, Emitter<NewArticleState> emit) async {
//     AllArticlesRepo repo = AllArticlesImpl();
//     try {
//       // emit(UpdateArticleLoadingState());
//       dynamic data;
//       data = await repo.updateArticle(event.newArticleModel, event.slug);
//       emit(UpdateArticleSuccessState(msg: "Article updated successfully"));
//     } catch (e) {
//       emit(UpdateArticleErroeState(msg: e.toString()));
//     }
//   }
// }
