import 'package:conduit/model/auth_model.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {}

class LoginSubmitEvent extends LoginEvent {
  AuthModel authModel;
  LoginSubmitEvent({required this.authModel});
  @override
  List<Object?> get props => [authModel];
}

class InitUserEvent extends LoginEvent {
  String msg;

  InitUserEvent({required this.msg});
  @override
  List<Object?> get props => [this.msg];
}
