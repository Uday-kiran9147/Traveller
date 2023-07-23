part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

abstract class AuthActionState extends AuthState {}

class NavigateToHomeScreenState extends AuthActionState {}

// loads the authentication ui
class ShowAuthScreenState extends AuthState {}

class AuthInitialState extends AuthState {}

class LoginSuccessState extends AuthActionState {
    final String SuccessMsg;

  LoginSuccessState(this.SuccessMsg);

}

class LoginFailureState extends AuthActionState {}

class RegisterSuccessState extends AuthActionState {
  final String SuccessMsg;
  RegisterSuccessState({required this.SuccessMsg});
}

class RegisterFailureState extends AuthActionState {
    final String failMsg;
  RegisterFailureState({required this.failMsg});
}

class AuthLoadingState extends AuthState {}
