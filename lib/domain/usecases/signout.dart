import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/constants/sharedprefs.dart';

class SignOut {
 static Future<bool> signoutuser() async {
    final firebaseAuth = FirebaseAuth.instance;
    try {
      await SHP.saveEmailSP("");
      await SHP.saveUserLoggedinStatusSP(false);
      await SHP.saveusernameSP("");
      await firebaseAuth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}
