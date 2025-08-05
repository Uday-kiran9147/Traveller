// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/presentation/pages/auth/cubit/auth_cubit_cubit.dart';
import 'package:traveler/presentation/pages/auth/ui/widgets/loginform.dart';
import 'package:traveler/presentation/widgets/snackbars.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({
    Key? key,
    required this.authBloc,
  }) : super(key: key);
  final AuthCubitCubit authBloc;
  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextFieldCustom(controller: _emailController, hint: 'Enter email', icon: Icons.email),
          const SizedBox(height: 10.0),
          TextFieldCustom(controller: _userNameController,hint: "Enter username",icon: Icons.person,),
          const SizedBox(height: 10.0),
          TextFieldCustom(controller: _passwordController,hint: "Enter password",icon: Icons.remove_red_eye,obscureText: true,),
          const SizedBox(height: 10.0),
          TextFieldCustom(controller: _confirmPasswordController,hint: "Enter confirm password",icon: Icons.password,obscureText: true,),
          const SizedBox(height: 10.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
            ),
            child: const Text("Signup"),
            onPressed: () {
              if (_confirmPasswordController.text == _passwordController.text) {
                BlocProvider.of<AuthCubitCubit>(context).authRegisterEvent(_userNameController.text, _emailController.text, _passwordController.text);
              } else {
                ScaffoldMessenger.of(context).clearSnackBars();
                customSnackbarMessage("Passwords do not match, please check", context, Colors.red);
              }
            },
          ),
        ],
      ),
    );
  }
}
