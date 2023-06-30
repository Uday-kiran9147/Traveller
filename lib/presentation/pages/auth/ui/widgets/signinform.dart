// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:traveler/domain/models/user.dart';
import '../../bloc/auth_bloc.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({
    Key? key,
    required this.authBloc,
  }) : super(key: key);
  final AuthBloc authBloc;
  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  TextEditingController _userNameController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _confirmPasswordController = TextEditingController();

  TextEditingController _emailController = TextEditingController();

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
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 88, 3, 85),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: "Enter email",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _userNameController,
            decoration: InputDecoration(
              hintText: "Enter username",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Enter password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Confirm password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 43, 8, 42),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text("Signup"),
            onPressed: () {
              if (_confirmPasswordController.text == _passwordController.text) {
                widget.authBloc.add(AuthRegisterEvent(
                    userregister: UserRegister(
                        profileurl: '',
                        uid: '',
                        bio: '',
                        followers: [],
                        following: [],
                        upcomingtrips: [],
                        tag: null,
                        reputation: 0,
                        username: _userNameController.text,
                        email: _emailController.text,
                        password: _passwordController.text)));
              } else {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Passwords do not match"),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
