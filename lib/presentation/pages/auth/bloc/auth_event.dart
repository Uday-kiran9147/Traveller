// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

/* 
authinitial
showauthscreenevent
loginfailedevent
loginsuccessevent




 */

@immutable
abstract class AuthEvent {}

class AuthInitialEvent extends AuthEvent {}

class loginFailedEvent extends AuthEvent {}

class NavigateToHomeScreenEvent extends AuthEvent {}

class LoginSuccessEvent extends AuthEvent {}

class RegisterSuccessEvent extends AuthEvent {}

class RegisterFailedEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final Userlogin userlogin;
  AuthLoginEvent({
    required this.userlogin,
  });
}

class AuthRegisterEvent extends AuthEvent {
  final UserRegister userregister;
  AuthRegisterEvent({
    required this.userregister,
  });
}
