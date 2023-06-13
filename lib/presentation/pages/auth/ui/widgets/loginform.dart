// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:traveler/domain/models/user.dart';
import 'package:traveler/domain/repositories/authentication.dart';
import 'package:traveler/presentation/pages/auth/bloc/auth_bloc.dart';

class LoginForm extends StatefulWidget {
  final AuthBloc authBloc;
  LoginForm({
    Key? key,
    required this.authBloc,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool showresetfield = false;

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _resetEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
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
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Enter password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text("Login"),
            onPressed: () async {
              // print(_emailController.text);
              // print(_passwordController.text);
              // Future<bool> isloginVerified = GoogleAuth.userLogin(
              //     _userNameController.text, _passwordController.text);
              // if (await isloginVerified) {
              //   Navigator.pushNamed(context, RouteName.home);
              // }
              widget.authBloc.add(AuthLoginEvent(
                  userlogin: Userlogin(
                      email: _emailController.text,
                      password: _passwordController.text)));
              print("login event added");
            },
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  showresetfield = !showresetfield;
                });
              },
              child: Text("Forgot Password?")),
          showresetfield
              ? Column(
                  children: [
                    TextField(
                      controller: _resetEmailController,
                      decoration: InputDecoration(
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
                        onPressed: () async {
                          // print(_resetEmailController.text);
                          GoogleAuth.resetPassword(_resetEmailController.text);
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
