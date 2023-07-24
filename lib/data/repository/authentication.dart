import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:traveler/data/repository/database.dart';
import '../../utils/constants/sharedprefs.dart';
import '../../domain/models/user.dart';

class GoogleAuth {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static String? userID = FirebaseAuth.instance.currentUser!.uid;
  DatabaseService db = DatabaseService();

  Future<UserRegister> getuser() async {
    final user = await DatabaseService.getcurrUser(
        FirebaseAuth.instance.currentUser!.uid);
    print(user);
    return UserRegister.fromMap(user!);
  }

// login

  Future<bool> signInWithGoogle() async {
    // print('sign-in method called');
    // Trigger the authentication flow
    // user-data will be found in googleUser below.
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return false;
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? userdata =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: userdata?.accessToken,
      idToken: userdata?.idToken,
    );
    // print(googleUser!.displayName);
    // print(googleUser.email);
    // print(googleUser);

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    return true;
  }

  Future<bool> signoutuser() async {
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
