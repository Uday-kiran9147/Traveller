import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:traveler/data/repository/database.dart';

class EditProfile {
  final String username;
  final String bio;
  final String tag;

  EditProfile(this.username, this.bio, this.tag);
  Future<bool> editPtofile() async {
    try {
      await DatabaseService.userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "username": username,
        "bio": bio,
        "tag": tag,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
    static Future<bool> saveprofilepicture(File image) async {
    try {
      final ref = await FirebaseStorage.instance.ref().child("userProfile").child(
          "Traveller-profile-${DatabaseService.userCollection.id}-${FirebaseAuth.instance.currentUser!.uid}");
      await ref.putFile(image);
      final imageurl = await ref.getDownloadURL();
      //  DocumentReference userdocreference= await userCollection.add({});
      await DatabaseService.userCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({
        "profileurl": imageurl.toString(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
