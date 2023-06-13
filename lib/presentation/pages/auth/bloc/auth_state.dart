part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

abstract class AuthActionState extends AuthState {}

class NavigateToHomeScreenState extends AuthActionState {}

// loads the authentication ui
class ShowAuthScreenState extends AuthState {}

class AuthInitialState extends AuthState {}

class LoginSuccessState extends AuthState {}

class LoginFailureState extends AuthState {}

class RegisterSuccessState extends AuthState {}

class RegisterFailureState extends AuthState {}

class AuthLoadingState extends AuthState {}
