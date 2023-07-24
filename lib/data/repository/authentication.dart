import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:traveler/data/repository/database.dart';
import '../../utils/constants/sharedprefs.dart';
import '../../domain/models/post.dart';
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

  static Future addComment(Comment comment) async {
    var getuser = await DatabaseService.userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => value['username']);
    print(json.encode(getuser));
    await DatabaseService.addComment(Comment(
        id: "",
        username: getuser,
        comment: comment.comment,
        userID: FirebaseAuth.instance.currentUser!.uid,
        date: DateTime.now().toString(),
        postID: comment.postID));
  }

  static Future<bool> postUserPost(Post post, File image) async {
    String getuser = await DatabaseService.userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => value["username"]);
    try {
      bool database = await DatabaseService.savepost(
          Post(
              id: "",
              popularity: 0,
              username: getuser,
              description: post.description,
              userID: FirebaseAuth.instance.currentUser!.uid,
              location: post.location,
              imageURL: post.imageURL,
              date: post.date),
          image);
      return database;
    } catch (e) {
      print("catch errer  $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>> registerUser(
      String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // The user is successfully created. You can perform additional tasks here, such as storing user data in Firestore.
      // Access the user object using (userCredential.user)
      DatabaseService.saveUserData(name, email, password);
      userID = userCredential.user!.uid;
      print('User created ID: ${userCredential.user!.uid}');
      return {"msg": "Acount created with $email", "status": true};
    } catch (e) {
      // Handle any errors that occur during the user creation process
      // print('Error creating user: ${e}');
      return {"msg": e.toString(), "status": false};
    }
  }

// login
  static Future<bool> userLogin(String email, password) async {
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

  static resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      }
    }
  }

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
