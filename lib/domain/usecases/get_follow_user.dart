import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class GetFollow{
  final String userid;GetFollow({required this.userid});
    Future<List<List<UserRegister>?>> getfollowList() async {
    List<List<UserRegister>?> biglist = List.empty(growable: true);
    List following = [];
    List followers = [];
    List<UserRegister> ing;
    List<UserRegister> ers;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .get()
        .then((value) async {
      UserRegister user = UserRegister.fromMap(value);
      following = user.following;
      ing = await getusers(following);
      followers = user.followers;
      ers = await getusers(followers);
      biglist = [ing, ers];
      return biglist;
      // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
    });
    return biglist;
  }

  Future<List<UserRegister>> getusers(List uidList) async {
    List<UserRegister>? users=[];
    if(uidList.isEmpty) return users;
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', whereIn: uidList)
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