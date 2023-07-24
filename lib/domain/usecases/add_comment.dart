// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/repository/database.dart';

class AddComment {
  final String comment;
  final String postid;

  const AddComment({
    required this.comment,
    required this.postid,
  });

  Future<void> addComment() async {
    var getuser = await DatabaseService.userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => value['username']);
    DocumentReference commentreference =
        await FirebaseFirestore.instance.collection('comments').add({
      'username': getuser,
      'comment': comment,
      'userID': FirebaseAuth.instance.currentUser!.uid,
      'date': DateTime.now().toString(),
      'postID': postid
    });
    await commentreference.update({
      "id": commentreference.id,
    });
  }
}
