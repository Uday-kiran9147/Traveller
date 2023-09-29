// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/presentation/pages/auth/cubit/auth_cubit_cubit.dart';
import 'package:traveler/presentation/widgets/snackbars.dart';
import 'package:traveler/utils/routes/route_names.dart';
import '../../home/ui/home.dart';
import 'widgets/account_ui.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  AuthCubitCubit authBloc = AuthCubitCubit();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubitCubit, AuthCubitState>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          Navigator.pushReplacementNamed(context, RouteName.authentication);
        }
        if (state is LoginFailureState) {
          customSnackbarMessage("Wrong email,password provided", context,
              Theme.of(context).colorScheme.error);
        }
        if (state is LoginSuccessState) {
          Navigator.pushReplacementNamed(context, RouteName.home);

          customSnackbarMessage(
              "You have successfully loggedin ${state.SuccessMsg}",
              context,
              Colors.green);
        }
        if (state is RegisterFailureState) {
          customSnackbarMessage(
              state.failMsg, context, Theme.of(context).colorScheme.error);
        }
        if (state is RegisterSuccessState) {
          customSnackbarMessage(state.SuccessMsg, context, Colors.green);
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case AuthScreenState:
            return AuthAccounts(authBloc: authBloc);
          case LoginSuccessState:
          return const HomeBloc();
        }
        return AuthAccounts(authBloc: authBloc);
      },
    );
  }
}
