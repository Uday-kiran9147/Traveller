import 'package:flutter/material.dart';
import 'package:traveler/config/theme/apptheme.dart';
import 'package:traveler/presentation/pages/auth/cubit/auth_cubit_cubit.dart';
import 'loginform.dart';
import 'signinform.dart';

class AuthAccounts extends StatefulWidget {
  const AuthAccounts({
    Key? key,
    required this.authBloc,
  }) : super(key: key);
  final AuthCubitCubit authBloc;

  @override
  _AuthAccountsState createState() => _AuthAccountsState();
}

class _AuthAccountsState extends State<AuthAccounts> {
  int? _formsIndex;

  @override
  void initState() {
    super.initState();
    _formsIndex = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        color: AppTheme.background,
        child: SingleChildScrollView(
          child: Column(            
            spacing: 20,
            children: <Widget>[
              const SizedBox(height: kToolbarHeight + 40),
              Text(
                "Welcome",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 30.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "Welcome to this awesome Traveller. \n You are awesome",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor:Colors.white,
                            backgroundColor:  AppTheme.buttonBackground,
                            shape: RoundedRectangleBorder(
                              side: _formsIndex == 1
                                  ? BorderSide(color: AppTheme.d)
                                  : BorderSide.none,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Text("Login"),
                          onPressed: () {
                            setState(() {
                              _formsIndex = 1;
                            });
                          },
                        ),
                        const SizedBox(width: 10.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: AppTheme.buttonBackground,
                            shape: RoundedRectangleBorder(
                              side: _formsIndex == 2
                                  ? BorderSide(color: AppTheme.d)
                                  : BorderSide.none,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Text("Signup"),
                          onPressed: () {
                            setState(() {
                              _formsIndex = 2;
                            });
                          },
                        ),
                      ],
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _formsIndex == 1
                          ? LoginForm(
                              authBloc: widget.authBloc,
                            )
                          : SignupForm(authBloc: widget.authBloc),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
