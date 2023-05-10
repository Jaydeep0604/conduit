import 'package:conduit/bloc/login_bloc/login_event.dart';
import 'package:conduit/config/cHiveStore.dart';
import 'package:conduit/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/auth_repo.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthRepo repo = AuthRepoImpl();
  // UserRepo userRepo = UserRepoImpl();
  LoginBloc() : super(LoginInitialState()) {
    on<LoginSubmitEvent>(_onLoginSubmit);
    on<InitUserEvent>(_onInitUser);
  }
  _onLoginSubmit(LoginSubmitEvent event, Emitter<LoginState> emit) async {
    try {
      emit(LoginLoadingState());
      dynamic jsonData;
      jsonData = await repo.login(event.authModel);
      // dynamic data = jsonData['user'];
      // print(data);
      // emit(LoginLoadingState());
      // dynamic data = await repo.login(event.authModel);

      bool isSessionOpen = await cHiveStore.openSession(
        UserAccessData(
          userName: jsonData['username'],
          email: jsonData['email'],
          image: jsonData['image'],
          token: jsonData['token'],
          bio: jsonData['bio'],
        ),
      );

      // await downloadStore.storeUserAccessData(
      //   UserAccessData(
      //     countryCode: data['country_code'],
      //     firstName: data['first_name'],
      //     lastName: data['last_name'],
      //     email: data['email'],
      //     dob: data['dob'],
      //     accessToken: data['accesstoken'],
      //     userId: data['user_id'].toString(),
      //     mobile: data['mobile_no'],
      //     loginType: data['login_type'],
      //   ),
      // );
  
      if (isSessionOpen) {
        add(InitUserEvent(msg: jsonData['user'].toString()));
      } else {
        emit(
          LoginErrorState(
            msg: "Cannot initialize the user",
          ),
        );
      }
      emit(
        LoginSuccessState(
          msg: jsonData["user"].toString(),
        ),
      );
    } catch (e) {
      emit(
        LoginErrorState(
          msg: e.toString(),
        ),
      );
    }
  }

  _onInitUser(InitUserEvent event, Emitter<LoginState> emit) async {
    try {
      emit(LoginLoadingState());
      // UserData userData = await userRepo.getUserProfileData();
      bool isStoredUser = await cHiveStore.isSession();
      if (isStoredUser) {
        emit(
          LoginSuccessState(
            msg: event.msg,
          ),
        );
        print("isStoredUser :: $isStoredUser");
      }
      if (LoginLoadingState == false) {
        emit(
          LoginSuccessState(
            msg: event.msg,
          ),
        );
      } else {
        emit(
          LoginErrorState(
            msg: "Cannot initialize the user",
          ),
        );
      }
    } catch (e) {
      emit(
        LoginErrorState(
          msg: e.toString(),
        ),
      );
    }
  }
}
// class LoginBloc extends Bloc<LoginEvent, LoginState> {
//   final LoginRepository loginRepository;

//   LoginBloc({required this.loginRepository}) : super(LoginInitial());

//   @override
//   Stream<LoginState> mapEventToState(LoginEvent event) async* {
//     if (event is LoginButtonPressed) {
//       yield LoginLoading();
//       try {
//         final data = await loginRepository.login(
//           event.email,
//           event.password,
//           event.userDeviceId,
//           event.fcmToken,
//         );
//         yield LoginSuccess(data: data);
//       } catch (error) {
//         yield LoginFailure(error: error.toString());
//       }
//     }
//   }
// }
