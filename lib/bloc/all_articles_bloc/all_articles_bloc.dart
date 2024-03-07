import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:conduit/model/all_article_model.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'all_articles_event.dart';
import 'all_articles_state.dart';

class AllArticlesBloc extends Bloc<AllArticlesEvent, AllArticlesState> {
  AllArticlesRepo repo;
  int offset = 0;
  final int limit = 10;
  AllArticlesBloc({required this.repo}) : super(AllArticlesInitialState()) {
    on<AllArticlesEvent>(_onAllArticlesEvent);
  }

  void _onAllArticlesEvent(
      AllArticlesEvent event, Emitter<AllArticlesState> emit) async {
    try {
      if (event is FetchNextAllArticlesEvent) {
        print(" The Length is ${event.length!.toInt()}");
        offset = event.length!.toInt();
      } else {
        offset = 0;
      }
      if (offset == 0) {
        emit(AllArticlesLoadingState());
      }

      List<AllArticlesModel> aData =
          (await repo.getAllArticlesData(offset: offset, limit: limit))
              .cast<AllArticlesModel>();

      if (aData.isEmpty) {
        emit(NoAllArticlesState());
      } else {
        bool hasReachedMax = aData.length < 10;

        if (event is FetchNextAllArticlesEvent) {
          final currentState = state;
          if (currentState is AllArticlesLoadedStete) {
            aData = [...currentState.allArticleslist, ...aData];
          }
        }

        emit(AllArticlesLoadedStete(
          allArticleslist: aData,
          hasReachedMax: hasReachedMax,
        ));
      }
    } on SocketException {
      emit(AllArticlesNoInternateState());
    } catch (e) {
      print(e);
      emit(AllArticlesErrorState(msg: e.toString()));
    }
  }
}
// _onFetchNextMyArticlesEvent(
//       MyArticlesEvent event, Emitter<MyArticlesState> emit) async {
//     MyArticlesLoadedStete curentstate = state as MyArticlesLoadedStete;
//     if (curentstate is MyArticlesLoadedStete) {
//       try {
//         // if (event is FetchNextMyArticlesEvent) {
//         //   offset = event.length!.toInt() + 1;
//         // }
//         List<AllArticlesModel> myArticleslist =
//             (await repo.getMyArticles(offset, limit)).cast<AllArticlesModel>();
//         if (myArticleslist.isEmpty) {
//           emit(
//             MyArticlesLoadedStete(
//                 myArticleslist: curentstate.myArticleslist,
//                 hasReachedMax: true),
//           );
//         } else {
//           emit(MyArticlesLoadedStete(
//               myArticleslist: curentstate.myArticleslist + myArticleslist));
//           offset = offset + 10;
//         }
//       } catch (e) {
//         emit(MyArticlesLoadedStete(
//             myArticleslist: curentstate.myArticleslist, hasReachedMax: true));
//       }
//     }
//   }

