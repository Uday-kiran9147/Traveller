import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class GetFollow{
    Future<List<List<UserRegister>?>> getfollowList() async {
    List<List<UserRegister>?> biglist = List.empty(growable: true);
    List following = [];
    List followers = [];
    var ing;
    var ers;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      UserRegister user = UserRegister.fromMap(value);
      following = user.following;
      ing = await getusers(following);
      followers = user.followers;
      ers = await getusers(followers);
      biglist = [ing??[], ers??[]];
      return biglist;
      // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
      print("Error Occured uday: $e");
    });
    return biglist;
  }

  Future<List<UserRegister>> getusers(List uid_list) async {
    List<UserRegister>? users;
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', whereIn: uid_list)
        .get()
        .then((value) {
      users = value.docs.map((e) => UserRegister.fromMap(e)).toList();
      // allusers = users;
    }).catchError((e) {
      print("Error Occured uday: $e");
    });
    return users!;
  }
}