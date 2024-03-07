import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {}

class LoginInitialState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginNoInternetState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoadingState extends LoginState {
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