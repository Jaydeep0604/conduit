import 'dart:math';

import 'package:conduit/model/profile_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {}

// fetch profile

class ProfileInitialState extends ProfileState {
  @override
  List<Object?> get props => [];
}
class ProfileNoInternetState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class NoProfileState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLoadingState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLoadedState extends ProfileState {
  List<ProfileModel> profileList;
  ProfileLoadedState({required this.profileList});
  @override
  List<Object?> get props => [profileList];
}

class ProfileLoadedErrorState extends ProfileState {
  String msg;
  ProfileLoadedErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
  @override
  String toString() {
    return msg;
  }
}

// update profile

class ProfileErrorState extends ProfileState {
  List<ProfileModel>? profileList;
  String message;
  ProfileErrorState({
    this.profileList,
    required this.message,
  });
  @override
  List<Object?> get props => [profileList, message, Random().nextDouble()];
}

class UpdateProfileLoadingState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class UpdateProfileSuccessState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class UpdateProfileErrorState extends ProfileState {
  String msg;
  UpdateProfileErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
  @override
  String toString() {
    return msg;
  }
}

// change password
class ChangePasswordLoadingState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ChangePasswordSuccessState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ChangePasswordErrorState extends ProfileState {
  List<ProfileModel>? profileList;
  String message;
  ChangePasswordErrorState({
    this.profileList,
    required this.message,
  });
  @override
  List<Object?> get props => [profileList, message, Random().nextDouble()];
}