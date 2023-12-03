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
  final emailKey = const Key('email_field');
  final passwordKey = const Key('password_field');
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
          TextFieldCustom(controller: _emailController,hint:"Enter email",icon: Icons.email,key: emailKey,),
          const SizedBox(height: 10.0),
          TextFieldCustom(controller: _passwordController,hint:"Enter password",icon: Icons.lock,obscureText: true,key: passwordKey,),
          const SizedBox(height: 10.0),
          ElevatedButton(key: const Key('login'),
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
            },
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  showresetfield = !showresetfield;
                });
              },
              child: const Text("Forgot Password?",style: TextStyle(color: Colors.orange),)),
          showresetfield
              ? Column(
                  children: [
          TextFieldCustom(controller: _resetEmailController,hint:"Enter reset-email",icon: Icons.restore,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
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
                          // print("Password reset link sent to your email");
                        })
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}

class TextFieldCustom extends StatelessWidget {

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  const TextFieldCustom({
    Key? key,
    this.obscureText=false,
    required this.controller,
    required this.hint,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(obscureText:obscureText ,
      controller: controller,
      decoration:  InputDecoration(prefixIcon: Icon(icon,color: Colors.green,),
        hintText: hint,hintStyle:const TextStyle(color: Colors.white,),
        border:const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
      ),
    );
  }
}
