import 'package:conduit/bloc/profile_bloc/profile_event.dart';
import 'package:conduit/bloc/profile_bloc/profile_state.dart';
import 'package:conduit/repository/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileRepo repo;
  ProfileBloc({required this.repo}) : super(ProfileInitialState()) {
    on<FetchProfileEvent>(_onFetchProfileEvent);
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
      emit(ProfileLoadedError(msg: e.toString()));
    }
  }
}
