part of 'auth_cubit_cubit.dart';

@immutable
abstract class AuthCubitState {}

class AuthCubitInitial extends AuthCubitState {}

class AuthLoadingState extends AuthCubitState {}
class AuthScreenState extends AuthCubitState {}
class LoginSuccessState extends AuthCubitState {
  final String SuccessMsg;

  LoginSuccessState(this.SuccessMsg);
}

class LoginFailureState extends AuthCubitState {
  final String failMsg;
  LoginFailureState({required this.failMsg});
}

class RegisterSuccessState extends AuthCubitState {
  final String SuccessMsg;
  RegisterSuccessState({required this.SuccessMsg});
}

class RegisterFailureState extends AuthCubitState {
  final String failMsg;
  RegisterFailureState({required this.failMsg});
}
