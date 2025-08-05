// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/config/theme/apptheme.dart';

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
  // ignore: unused_field
  final TextEditingController _resetEmailController = TextEditingController();
  final emailKey = const Key('email_field');
  final passwordKey = const Key('password_field');
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          TextFieldCustom(
            controller: _emailController,
            hint: "Enter email",
            icon: Icons.email,
            key: emailKey,
          ),
          const SizedBox(height: 10.0),
          TextFieldCustom(
            controller: _passwordController,
            hint: "Enter password",
            icon: Icons.lock,
            obscureText: true,
            key: passwordKey,
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            key: const Key('login'),
            style: ElevatedButton.styleFrom(),
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
            child: const Text(
              "Forgot Password?",
              style: TextStyle(),
            ),
          ),
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
    this.obscureText = false,
    required this.controller,
    required this.hint,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: AppTheme.primaryColor,
        ),
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 253, 2, 240),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: const Color.fromARGB(255, 100, 34, 206)),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
