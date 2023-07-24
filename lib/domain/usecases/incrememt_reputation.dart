import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:traveler/data/repository/database.dart';

class IncrementReputation {
  final String postid;

  IncrementReputation(this.postid);
  Future<bool> incrementReputation() async {
    try {
      var post = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postid)
          .get();
      // user cannot increment popularity of his own post and user reputation will not increment for his own post
      if (post['userid'] != FirebaseAuth.instance.currentUser!.uid) {
        await DatabaseService.postCollection
            .doc(postid)
            .update({'popularity': FieldValue.increment(2)});
        await DatabaseService.userCollection
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'reputation': FieldValue.increment(1)});
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
