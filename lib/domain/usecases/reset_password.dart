import 'package:firebase_auth/firebase_auth.dart';

class ResetPassword{
  final String email;

  ResetPassword(this.email);
    void resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      }
    }
  }
}