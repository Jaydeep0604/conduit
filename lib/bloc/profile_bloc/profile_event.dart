import 'package:conduit/model/auth_model.dart';
import 'package:conduit/model/profile_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {}

class FetchProfileEvent extends ProfileEvent {
  // FetchProfileEvent({});
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class DeleteProfileEvent extends ProfileEvent {
  AuthModel authModel;

  DeleteProfileEvent({
    required this.authModel,
  });
  @override
  List<Object?> get props => [
        authModel,
      ];
}

// ignore: must_be_immutable
class ChangeProfileEvent extends ProfileEvent {
  ProfileModel profileModel;
  ChangeProfileEvent({required this.profileModel});
  @override
  List<Object?> get props => [profileModel];
}
