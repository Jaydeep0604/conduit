import 'package:conduit/model/auth_model.dart';
import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {}

class RegisterNoInternetState extends RegisterState {
  @override
  List<Object?> get props => [];
}

class RegisterInitialState extends RegisterState {
  @override
  List<Object?> get props => [];
}

class RegisterLoadingState extends RegisterState {
  AuthModel authModel;
  RegisterLoadingState({required this.authModel});
  @override
  List<Object?> get props => [authModel];
}

// ignore: must_be_immutable
class RegisterDoneState extends RegisterState {
  AuthModel authModel;
  String msg;
  RegisterDoneState({required this.authModel, required this.msg});
  @override
  List<Object?> get props => [authModel, msg];
}

// ignore: must_be_immutable
class RegisterErrorState extends RegisterState {
  AuthModel authModel;
  String msg;
  RegisterErrorState({required this.msg, required this.authModel});
  @override
  List<Object?> get props => [authModel, msg];

  // @override
  // String toString() {
  //   return "error";
  // }
}
