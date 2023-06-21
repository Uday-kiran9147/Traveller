import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/post.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // referenceing collections in database
  static final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  static final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  static Future addComment(Comment comment) async {
    await userCollection.doc(comment.userID);
    var user = await userCollection.doc(comment.userID).get();
    // var post = await postCollection.doc(uid).get();

    DocumentReference commentreference =
        await FirebaseFirestore.instance.collection('comments').add({
      'username': comment.username,
      'comment': comment.comment,
      'userID': comment.userID,
      'date': DateTime.now().toString(),
      'postID': comment.postID
    });
    await commentreference.update({
      "id": commentreference.id,
    });
  }

  Future saveUserData(String name, String email) async {
    return await userCollection
        .doc(uid)
        .set({"username": name, "email": email, "uid": uid});
  }

  static Future<bool> savepost(Post post, File image) async {
    // print("database post");

    try {
      DocumentReference postdocumentReference = await postCollection.add({
        "id": "",
        "description": post.description,
        "imageurl": "",
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

      // final docRef = postCollection.doc("RQ957wrtC6PiqUQsQA4Z");
      return true;
    } catch (e) {
      print("error in saving post ");
      return false;
    }
  }

  static Future<DocumentSnapshot?> getcurrUser(String uid) async {
    print("getting user");
    final docRef = await userCollection.doc(uid);
    docRef.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot["username"]}');
        return documentSnapshot;
      } else {
        print('Document does not exist on the database');
        return null;
      }
    });
    return null;
  }

  static Future getpos() async {
    final docRef = postCollection.doc("RQ957wrtC6PiqUQsQA4Z");
    //------------for offline fetching support------------
    // const source = Source.cache;
    // docRef.get(const GetOptions(source: source)).then(
    //   (res) {
    //     // print("Successfully completed");
    //     print(res.data());
    //   },
    //   onError: (e) => print("Error completing: $e"),
    // );
    //------------------------------------------------------
    await docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }
}
