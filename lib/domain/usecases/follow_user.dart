import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:traveler/data/repository/database.dart';

class FollowUser{
  final String userid;
  final List random_User_Followers;

  FollowUser({required this.userid,required  this.random_User_Followers});
  Future<bool> follow() async {
    final String uidCurrentuser = FirebaseAuth.instance.currentUser!.uid;

    try {
      if (random_User_Followers.contains(uidCurrentuser)) {
        await DatabaseService.userCollection.doc(userid).update({
          'followers': FieldValue.arrayRemove([uidCurrentuser])
        });
        await DatabaseService. userCollection.doc(uidCurrentuser).update({
          'following': FieldValue.arrayRemove([userid])
        });
      } else {
        await DatabaseService.userCollection.doc(userid).update({
          'followers': FieldValue.arrayUnion([uidCurrentuser])
        });
        await DatabaseService. userCollection.doc(uidCurrentuser).update({
          'following': FieldValue.arrayUnion([userid])
        });
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}