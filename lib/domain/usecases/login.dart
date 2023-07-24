import 'package:firebase_auth/firebase_auth.dart';

import '../../data/repository/database.dart';
import '../../utils/constants/sharedprefs.dart';

class Login {
  final String email;
  final String password;

  Login({required this.email,required this.password});
  Future<bool> userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // print(user.user!);
      await SHP.saveEmailSP(email);
      await SHP.saveUserLoggedinStatusSP(true);
      await DatabaseService.getcurrUser(FirebaseAuth.instance.currentUser!.uid);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No User Found for that Email");
      } else if (e.code == 'wrong-password') {
        print("Wrong Password Provided by User");
        return false;
      }
      return false;
    }
  }
}
