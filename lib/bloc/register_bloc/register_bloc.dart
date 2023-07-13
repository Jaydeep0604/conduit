import 'package:conduit/bloc/register_bloc/register_event.dart';
import 'package:conduit/bloc/register_bloc/register_state.dart';
import 'package:conduit/model/auth_model.dart';
import 'package:conduit/repository/auth_repo.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  AuthRepo authRepo;
  // UserRepo userRepo = UserRepoImpl();

  RegisterBloc({required this.authRepo}) : super(RegisterInitialState()) {
    on<RegisterSubmitEvent>(_onRegisterSubmitEvent);
    on<InitUserEvent>(_onInitUser);
  }
  _onRegisterSubmitEvent(
      RegisterSubmitEvent event, Emitter<RegisterState> emit) async {
    try {
      emit(RegisterLoadingState(authModel: event.authModel));
      dynamic jsonData = await authRepo.register(event.authModel);
      print("register $jsonData");
      // dynamic data = jsonData['user'];
      // bool isSessionOpen = await cHiveStore.openSession(
      //   UserAccessData(
      //     userName: data['username'],
      //     email: data['email'],
      //     token: data['token'],
      //   ),
      // );
      // if (isSessionOpen) {
      //   add(InitUserEvent(msg: jsonData['message']));
      // } else {
      //   emit(
      //     RegisterErrorState(
      //       authModel: event.authModel,
      //       msg: "Cannot initialize the user",
      //     ),
      //   );
      // }
      emit(
        RegisterDoneState(
            authModel: (state.props[0] as AuthModel),
            msg: jsonData['user']
          ),
      );
    } catch (e) {
      emit(
        RegisterErrorState(
          authModel: event.authModel,
          msg: e.toString(),
        ),
      );
    }
  }

  _onInitUser(InitUserEvent event, Emitter<RegisterState> emit) async {
    try {
      emit(RegisterLoadingState(authModel: (state.props[0] as AuthModel)));
      // UserData userData = await userRepo.getUserProfileData();
      // bool isStoredUser = await cHiveStore.storeUserData(userData);
      if (state is RegisterDoneState) {
        emit(
          RegisterDoneState(
            authModel: (state.props[0] as AuthModel),
            msg: event.msg,
          ),
        );
      } else {
        emit(
          RegisterErrorState(
            authModel: (state.props[0] as AuthModel),
            msg: "Cannot initialize the user",
          ),
        );
      }
    }
    //  on SocketException {
    //   emit(
    //     RegisterErrorState(
    //       authModel: (state.props[0] as AuthModel),
    //       msg: ApiConstant.COULDT_REACH.toString(),
    //     ),
    //   );
    // }
    catch (e) {
      emit(
        RegisterErrorState(
          authModel: (state.props[0] as AuthModel),
          msg: e.toString(),
        ),
      );
    }
  }
}
