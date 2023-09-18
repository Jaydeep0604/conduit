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
  
  String msg;
  RegisterDoneState({
     required this.msg});
  @override
  List<Object?> get props => [msg];
}

// ignore: must_be_immutable
class RegisterErrorState extends RegisterState {
  
  String msg;
  RegisterErrorState({required this.msg, });
  @override
  List<Object?> get props => [msg];

  // @override
  // String toString() {
  //   return "error";
  // }
}
