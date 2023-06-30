// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/presentation/widgets/snackbars.dart';
import 'package:traveler/utils/routes/route_names.dart';
import '../bloc/auth_bloc.dart';
import 'widgets/account_ui.dart';

class AuthenticationScreen extends StatefulWidget {
  AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    super.initState();
    authBloc.add(AuthInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: authBloc,
      listenWhen: (previous, current) => current is AuthActionState,
      buildWhen: (previous, current) => current is! AuthActionState,
      listener: (context, state) {
        if (state is NavigateToHomeScreenState) {
          Navigator.pushReplacementNamed(context, RouteName.home);
        }
        if (state is LoginFailureState) {
          customSnackbarMessage("Wrong E-mail,Password Provided by User",
              context, Theme.of(context).colorScheme.error);
        }
        if (state is LoginSuccessState) {
          customSnackbarMessage(
              "You have successfully loggedin", context, Colors.green);
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case ShowAuthScreenState:
            return AuthAccounts(
              authBloc: authBloc,
            );
          case RegisterSuccessState:
            return AuthAccounts(
              authBloc: authBloc,
            );

          default:
            return SizedBox();
        }
      },
    );
  }
}
