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

  final _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

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
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFieldCustom(
              controller: _emailController,
              hint: 'Enter email',
              icon: Icons.email,
              validator: _validateEmail,
            ),
            const SizedBox(height: 10.0),
            TextFieldCustom(
              controller: _userNameController,
              hint: "Enter username",
              icon: Icons.person,
              validator: _validateUsername,
            ),
            const SizedBox(height: 10.0),
            TextFieldCustom(
              controller: _passwordController,
              hint: "Enter password",
              icon: Icons.remove_red_eye,
              obscureText: true,
              validator: _validatePassword,
            ),
            const SizedBox(height: 10.0),
            TextFieldCustom(
              controller: _confirmPasswordController,
              hint: "Enter confirm password",
              icon: Icons.password,
              obscureText: true,
              validator: _validateConfirmPassword,
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(),
              child: const Text("Signup"),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  BlocProvider.of<AuthCubitCubit>(context).authRegisterEvent(
                    _userNameController.text,
                    _emailController.text,
                    _passwordController.text,
                  );
                } else {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  customSnackbarMessage("Please fix the errors in the form", context, Colors.red);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
