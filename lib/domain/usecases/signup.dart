import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class SignUp {
  final String name;
  final String email;
  final String password;

  SignUp({required this.name, required this.email, required this.password});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<Map<String, dynamic>> registerUser() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email,password: password);
      // The user is successfully created. You can perform additional tasks here, such as storing user data in Firestore.
      // Access the user object using (userCredential.user)
     await saveUserData();
      // userID = userCredential.user!.uid;
      print('User created ID: ${userCredential.user!.uid}');
      return {"msg": "Acount created with $email", "status": true};
    } catch (e) {
      // Handle any errors that occur during the user creation process
      // print('Error creating user: ${e}');
      return {"msg": e.toString(), "status": false};
    }
  }

  Future saveUserData() async {
    UserRegister user = UserRegister(
      reputation: 0,
      bio: null,
      username: name,
      email: email,
      password: password,
      tag: null,
      upcomingtrips: [],
      profileurl: null,
      followers: [],
      following: [],
      uid: FirebaseAuth.instance.currentUser!.uid,
    );
    return await userCollection
        .doc(
          FirebaseAuth.instance.currentUser!.uid,
        )
        .set(user.toMap());
  }
}
