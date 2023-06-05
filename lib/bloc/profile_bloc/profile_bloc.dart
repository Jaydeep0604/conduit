import 'package:conduit/bloc/article_bloc/article_state.dart';
import 'package:conduit/bloc/profile_bloc/profile_event.dart';
import 'package:conduit/bloc/profile_bloc/profile_state.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:conduit/repository/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  AllArticlesRepo repo;
  ProfileBloc({required this.repo}) : super(ProfileInitialState()) {
    on<FetchProfileEvent>(_onFetchProfileEvent);
    on<UpdateProfileEvent>(_onUpdateProfileEvent);
  }

  _onFetchProfileEvent(
      FetchProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoadingState());

      dynamic aData = (await repo.getProfileData());

      if (aData != null) {
        //   emit(NoProfileState());
        // } else {
        emit(ProfileLoadedState(profileList: aData));
      }
    } catch (e) {
      print(e);
      emit(ProfileLoadedErrorState(msg: e.toString()));
    }
  }

  _onUpdateProfileEvent(
      UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileUpdateLoadingState());
    try {
      dynamic data = await repo.updateProfile(event.profileModel);
      if (data != null) {
        emit(ProfileUpdateSuccessState());
      } else {
        emit(NoProfileState());
      }
    } catch (e) {
      print(e);
      emit(ProfileUpdateErrorState(msg: e.toString()));
    }
  }
}
