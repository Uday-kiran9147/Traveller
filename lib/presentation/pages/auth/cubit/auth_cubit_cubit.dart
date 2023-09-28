import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../domain/usecases/login.dart';
import '../../../../domain/usecases/signup.dart';
import '../../../../utils/constants/sharedprefs.dart';

part 'auth_cubit_state.dart';

class AuthCubitCubit extends Cubit<AuthCubitState> {
  AuthCubitCubit() : super(AuthCubitInitial()){
    emit(AuthCubitInitial());}

  void authInitialEvent() {
    emit(AuthScreenState());
  }

  void authLoginEvent(String email, String password) async {
    Login login = Login(email: email, password: password);
    await login.userLogin().then((value) {
      if (value == true) {
        emit(LoginSuccessState(email));
        // emit((NavigateToHomeScreenState()));
        SHP.saveEmailSP(email);
        SHP.saveUserLoggedinStatusSP(true);
        print("login success");
      } else {
        emit((LoginFailureState(failMsg: "Cubit failed")));
        print("login failed");
      }
    });
  }

  void authRegisterEvent(String username, String email, String password) async {
    SignUp signUp =
        SignUp(name: username, email: email, password:password);
    await signUp.registerUser().then((value) async {
      var isvalid = value['status'];
      print(value);
      if (isvalid == true) {
        emit(RegisterSuccessState(SuccessMsg: value['msg']));

        await SHP.saveEmailSP(email);
        await SHP.saveusernameSP(username);
      } else {
        emit(RegisterFailureState(failMsg: value['msg']));
      }
    });
  }
}
