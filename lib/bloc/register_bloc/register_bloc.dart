import 'dart:io';

import 'package:conduit/bloc/register_bloc/register_event.dart';
import 'package:conduit/bloc/register_bloc/register_state.dart';
import 'package:conduit/repository/auth_repo.dart';
import 'package:http/http.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  AuthRepo repo;
  // UserRepo userRepo = UserRepoImpl();

  RegisterBloc({required this.repo}) : super(RegisterInitialState()) {
    on<RegisterSubmitEvent>(_onRegisterSubmitEvent);
    // on<InitUserEvent>(_onInitUser);
  }
  _onRegisterSubmitEvent(
      RegisterSubmitEvent event, Emitter<RegisterState> emit) async {
    try {
      emit(RegisterLoadingState(authModel: event.authModel));
      Response data = await repo.register(event.authModel);
      print("register $data");
      if (data.statusCode == 201) {
        emit(
          RegisterDoneState(msg: "User Created successfuly"),
        );
      } else {
        emit(RegisterErrorState(
          msg: data.body,
        ));
      }
    } on SocketException {
      emit(RegisterNoInternetState());
    } catch (e) {
      emit(
        RegisterErrorState(
          msg: e.toString(),
        ),
      );
    }
  }
}
