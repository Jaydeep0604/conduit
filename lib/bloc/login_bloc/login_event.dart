import 'package:conduit/model/auth_model.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {}

// ignore: must_be_immutable
class LoginSubmitEvent extends LoginEvent {
  AuthModel authModel;
  LoginSubmitEvent({required this.authModel});
  @override
  List<Object?> get props => [authModel];
}

// ignore: must_be_immutable
class InitUserEvent extends LoginEvent {
  String msg;

  InitUserEvent({required this.msg});
  @override
  List<Object?> get props => [this.msg];
}
// class InitUserEvent extends LoginEvent {

//   InitUserEvent();
//   @override
//   List<Object?> get props => [];
// }

// abstract class LoginEvent extends Equatable {
//   const LoginEvent();

//   @override
//   List<Object> get props => [];
// }

// class LoginButtonPressed extends LoginEvent {
//   final String email;
//   final String password;
//   final String userDeviceId;
//   final String fcmToken;

//   const LoginButtonPressed({
//     required this.email,
//     required this.password,
//     required this.userDeviceId,
//     required this.fcmToken,
//   });

//   @override
//   List<Object> get props => [email, password, userDeviceId, fcmToken];
// }
