import 'package:flutter/material.dart';
import '../../../../../data/repository/authentication.dart';
import '../../bloc/auth_bloc.dart';
import 'loginform.dart';
import 'signinform.dart';

class AuthAccounts extends StatefulWidget {
  const AuthAccounts({
    Key? key,
    required this.authBloc,
  }) : super(key: key);
  final AuthBloc authBloc;

  @override
  _AuthAccountsState createState() => _AuthAccountsState();
}

class _AuthAccountsState extends State<AuthAccounts> {
  late bool formVisible;
  int? _formsIndex;
  GoogleAuth googleAuth = GoogleAuth();

  @override
  void initState() {
    super.initState();
    formVisible = false;
    _formsIndex = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage(room4),
          //   fit: BoxFit.cover,
          // ),
          ),
      child: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset('assets/onb1.jpg',fit: BoxFit.cover,),
          ),
          Container(
            color: Colors.black54,
            child: Column(
              children: <Widget>[
                const SizedBox(height: kToolbarHeight + 40),
                Expanded(
                  child: Column(
                    children: const <Widget>[
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
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: <Widget>[
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Color.fromARGB(255, 43, 8, 42),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text("Login"),
                        onPressed: () {
                          setState(() {
                            formVisible = true;
                            _formsIndex = 1;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Color.fromARGB(255, 43, 8, 42),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text("Signup"),
                        onPressed: () {
                          setState(() {
                            formVisible = true;
                            _formsIndex = 2;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10.0),
                  ],
                ),
                const SizedBox(height: 40.0),
                // OutlinedButton.icon(
                //   style: OutlinedButton.styleFrom(
                //     side: const BorderSide(color: Colors.red),
                //     backgroundColor: Colors.red,
                //     foregroundColor: Colors.white,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20.0),
                //     ),
                //   ),
                //   icon: const Icon(Icons.add),
                //   label: const Text("Continue with Google"),
                //   onPressed: () {
                //     // googleAuth.signInWithGoogle();
                //   },
                // ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: (!formVisible)
                ? null
                : Container(
                    color: Colors.black54,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: _formsIndex == 1
                                    ? Colors.white
                                    : Colors.black,
                                backgroundColor: _formsIndex == 1
                                    ?  Color.fromARGB(255, 43, 8, 42)
                                    : Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
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
                                foregroundColor: _formsIndex == 2
                                    ? Colors.white
                                    : Colors.black,
                                backgroundColor: _formsIndex == 2
                                    ?  Color.fromARGB(255, 43, 8, 42)
                                    : Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                              child: const Text("Signup"),
                              onPressed: () {
                                setState(() {
                                  _formsIndex = 2;
                                });
                              },
                            ),
                            const SizedBox(width: 10.0),
                            IconButton(
                              color: Colors.white,
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  formVisible = false;
                                });
                              },
                            )
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
                  ),
          )
        ],
      ),
    ));
  }
}
