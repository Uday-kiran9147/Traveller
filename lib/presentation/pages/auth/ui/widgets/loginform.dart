// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/domain/usecases/reset_password.dart';
import 'package:traveler/presentation/pages/auth/cubit/auth_cubit_cubit.dart';

class LoginForm extends StatefulWidget {
  final AuthCubitCubit authBloc;
  const LoginForm({
    Key? key,
    required this.authBloc,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool showresetfield = false;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _resetEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 88, 3, 85),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: "Enter email",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Enter password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 43, 8, 42),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text("Login"),
            onPressed: () async {
              BlocProvider.of<AuthCubitCubit>(context).authLoginEvent(
                  _emailController.text, _passwordController.text);
              print("function called");
            },
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  showresetfield = !showresetfield;
                });
              },
              child: const Text("Forgot Password?")),
          showresetfield
              ? Column(
                  children: [
                    TextField(
                      controller: _resetEmailController,
                      decoration: const InputDecoration(
                        hintText: "Enter reset-email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text("Reset Password"),
                        onPressed: () {
                          ResetPassword resetPassword =
                              ResetPassword(_resetEmailController.text);
                          resetPassword.resetPassword();
                          print("Password reset link sent to your email");
                        })
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
