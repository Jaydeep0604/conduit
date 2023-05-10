import 'dart:math';

import 'package:conduit/bloc/profile_bloc/profile_event.dart';
import 'package:conduit/bloc/profile_bloc/profile_state.dart';
import 'package:conduit/model/auth_model.dart';
import 'package:conduit/repository/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileRepo repo;
  ProfileBloc({required this.repo}) : super(ProfileInitialState()) {
    on<FetchProfileEvent>(_onFetchProfileEvent);
    // on<AddProfileEvent>(_onAddProfileEvent);

    // on<CheckMaxProfileEvent>(_onCheckMaxProfileEvent);
    // on<ChangeProfileEvent>(_onChangeProfileEvent);

    // on<DeleteProfileEvent>(_onDeleteProfileEvent);
  }

  _onFetchProfileEvent(
      FetchProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoadingState());

      dynamic aData = (await repo.getUserProfileData()).cast<AuthModel>();
      // dynamic profiles = await  repo.getProfile();
      //  emit(ProfileLoadedState(profileList: profiles));
      if (aData!= null) {
      //   emit(NoProfileState());
      // } else {
        emit(ProfileLoadedState(profileList: aData));
      }
    } catch (e) {
      // dynamic profiles = await  repo.getProfile();
      print(e);
      emit(ProfileLoadedError(msg: e.toString()));
    }
  }
}
