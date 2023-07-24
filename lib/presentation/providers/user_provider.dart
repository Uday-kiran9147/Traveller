import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/domain/models/user.dart';

class UserProvider extends ChangeNotifier {
  UserRegister? _user = UserRegister(
      username: '',
      email: '',
      password: '',
      upcomingtrips: [],
      uid: '',
      reputation: 0,
      followers: [],
      following: []);

  Future<UserRegister> getuser() async {
    UserRegister getuser = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => UserRegister.fromMap(value));
    _user = getuser;
    notifyListeners();
    return getuser;
  }

  UserRegister get user => _user!;
}
