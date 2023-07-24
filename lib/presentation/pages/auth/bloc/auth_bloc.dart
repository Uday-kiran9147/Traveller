import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traveler/domain/models/user.dart';
import 'package:traveler/utils/constants/sharedprefs.dart';

import '../../../../data/repository/authentication.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<AuthInitialEvent>(authInitialEvent);
    on<AuthLoginEvent>(authLoginEvent);
    on<AuthRegisterEvent>(authRegisterEvent);
  }

  FutureOr<void> authInitialEvent(
      AuthInitialEvent event, Emitter<AuthState> emit) {
    emit(ShowAuthScreenState());
    print("authLoginEvent");
  }

  FutureOr<void> authLoginEvent(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    await GoogleAuth.userLogin(event.userlogin.email, event.userlogin.password)
        .then((value) {
      if (value == true) {
        emit(LoginSuccessState(event.userlogin.email));
        emit((NavigateToHomeScreenState()));
        SHP.saveEmailSP(event.userlogin.email);
        SHP.saveUserLoggedinStatusSP(true);
        print("login success");
      } else {
        emit((LoginFailureState()));
        print("login failed");
      }
    });
  }

  FutureOr<void> authRegisterEvent(
      AuthRegisterEvent event, Emitter<AuthState> emit) async {
    await GoogleAuth.registerUser(event.userregister.username,
            event.userregister.email, event.userregister.password)
        .then((value) async {
          var isvalid=value['status'];
          print(value);
      if (isvalid == true) {
        emit(RegisterSuccessState(SuccessMsg:value['msg'] ));

       await SHP.saveEmailSP(event.userregister.email);
       await SHP.saveusernameSP(event.userregister.username);
      }
      else{
        emit(RegisterFailureState(failMsg: value['msg']));
      }
    });
  }
}
