// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/post.dart';

class SavePost {
  final Post post;
  final File image;
  const SavePost({
    required this.post,
    required this.image,
  });
  static final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  Future<bool> savepost() async {
    try {
      DocumentReference postdocumentReference = await postCollection.add({
        "id": "",
        "description": post.description,
        "imageurl": "",
        'popularity': 0,
        "location": post.location,
        "username": post.username,
        "userid": post.userID,
        "date": DateTime.now().toString(),
      });
      final ref = FirebaseStorage.instance.ref().child("userPost").child(
          "Traveller-posts-${post.username}-${postdocumentReference.id}.jpeg");
      await ref.putFile(image);
      final imageurl = await ref.getDownloadURL();

      await postdocumentReference.update({
        "id": postdocumentReference.id,
        "imageurl": imageurl.toString(),
      });
      print("database created");
      return true;
    } catch (e) {
      print("error in saving post ");
      return false;
    }
  }
}
