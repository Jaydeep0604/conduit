import 'dart:math';
import 'package:conduit/model/profile_model.dart';
import 'package:equatable/equatable.dart';

  abstract class ProfileState extends Equatable {}

  // fetch profile


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

  class ProfileUpdateLoadingState extends ProfileState {
    @override
    List<Object?> get props => [];
  }
  class ProfileUpdateSuccessState extends ProfileState {
    @override
    List<Object?> get props => [];
  }

  class ProfileUpdateErrorState extends ProfileState {
    String msg;
    ProfileUpdateErrorState({required this.msg});
    @override
    List<Object?> get props => [msg];
    @override
    String toString() {
      return msg;
    }
  }

  // class ProfileSuccessState extends ProfileState {
  //   List<ProfileModel>? profileList;
  //   ProfileSuccessState({this.profileList});
  //   @override
  //   List<Object?> get props => [profileList];
  // }

  // class PasswordChangedState extends ProfileState {
  //   String message;
  //   PasswordChangedState({required this.message});
  //   @override
  //   List<Object?> get props => [message];
  // }

  // class ProfileUserErrorState extends ProfileState {
  //   String msg;
  //   ProfileUserErrorState({required this.msg});
  //   @override
  //   List<Object?> get props => [msg];
  //   @override
  //   String toString() {
  //     return msg;
  //   }
  // }
