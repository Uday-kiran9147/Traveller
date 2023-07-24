// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../data/repository/database.dart';

class SavePost {
  final String description;
  final String location;
  final String date;
  final File? image;
  SavePost({
    required this.description,
    required this.location,
    required this.date,
    required this.image,
  });
  static final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  Future<bool> savepost() async {
    try {
      var username = await DatabaseService.userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) => value['username'])
          .catchError((e) {
        print("error in getting username");
        print(e.toString());
      });
      if (username.toString().isEmpty) {
        return false;
      }
      DocumentReference postdocumentReference = await postCollection.add({
        "id": "",
        "description": description,
        "imageurl": "",
        'popularity': 0,
        "location": location,
        "username": username,
        "userid": FirebaseAuth.instance.currentUser!.uid,
        "date": date,
      });
      final ref = FirebaseStorage.instance.ref().child("userPost").child(
          "Traveller-posts-${username}-${postdocumentReference.id}.jpeg");
      await ref.putFile(image!);
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
