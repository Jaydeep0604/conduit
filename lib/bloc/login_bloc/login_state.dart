import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {}

class LoginNoInternetState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginInitialState extends LoginState {
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class LoginSuccessState extends LoginState {
  String msg;
  LoginSuccessState({required this.msg});
  @override
  List<Object?> get props => [msg];
}

class LoginLoadingState extends LoginState {
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class LoginErrorState extends LoginState {
  String msg;
  LoginErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
  @override
  String toString() {
    return msg;
  }
}

// ignore: must_be_immutable
// class LoginRegisterState extends LoginState {
//   LoginModel loginModel;
//   LoginRegisterState({required this.loginModel});
//   @override
//   List<Object?> get props => [loginModel];
// }

// abstract class LoginState extends Equatable {
//   const LoginState();

//   @override
//   List<Object> get props => [];
// }

// class LoginInitial extends LoginState {}

// class LoginLoading extends LoginState {}

// class LoginSuccess extends LoginState {
//   final dynamic data;

//   const LoginSuccess({required this.data});

//   @override
//   List<Object> get props => [data];
// }

// class LoginFailure extends LoginState {
//   final String error;

//   const LoginFailure({required this.error});

//   @override
//   List<Object> get props => [error];
// }
