// ignore_for_file: must_be_immutable

import 'package:conduit/model/auth_model.dart';
import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {}

class RegisterSubmitEvent extends RegisterEvent {
  AuthModel authModel;
  RegisterSubmitEvent({required this.authModel});
  @override
  List<Object?> get props => [authModel];
}


class InitUserEvent extends RegisterEvent {
  String msg;

  InitUserEvent({required this.msg});
  @override
  List<Object?> get props => [this.msg];
}
