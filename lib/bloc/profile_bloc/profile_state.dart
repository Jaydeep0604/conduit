import 'dart:math';

import 'package:conduit/model/auth_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {}

class ProfileInitialState extends ProfileState {
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


// ignore: must_be_immutable
class ProfileLoadedState extends ProfileState {
  List<AuthModel> profileList;
  ProfileLoadedState({required this.profileList});
  @override
  List<Object?> get props => [profileList];
}

// ignore: must_be_immutable
class ProfileLoadedError extends ProfileState {
  String msg;
  ProfileLoadedError({required this.msg});
  @override
  List<Object?> get props => [msg];
}

// ignore: must_be_immutable
class ProfileErrorState extends ProfileState {
  List<AuthModel>? profileList;
  String message;
  ProfileErrorState({
    this.profileList,
    required this.message,
  });
  @override
  List<Object?> get props => [profileList, message, Random().nextDouble()];
}


// ignore: must_be_immutable
class ProfileSuccessState extends ProfileState {
  List<AuthModel>? profileList;
  ProfileSuccessState({this.profileList});
  @override
  List<Object?> get props => [profileList];
}



// ignore: must_be_immutable
class PasswordChangedState extends ProfileState {
  String message;
  PasswordChangedState({required this.message});
  @override
  List<Object?> get props => [message];
}

// ignore: must_be_immutable
class ProfileUserErrorState extends ProfileState {
  String msg;
  ProfileUserErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
  @override
  String toString() {
    return msg;
  }
}
