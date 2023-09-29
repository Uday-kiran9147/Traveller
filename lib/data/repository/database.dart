import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // final String uidCurrentuser = FirebaseAuth.instance.currentUser!.uid;
  // DatabaseService({required this.uid});

  // referenceing collections in database
  static final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  static final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');
      static final CollectionReference travelStoryCollection =
      FirebaseFirestore.instance.collection('travelstory');

  static Future<DocumentSnapshot?> getcurrUser(String uid) async {
    print("getting user");
    final docRef = userCollection.doc(uid);
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
        // final data = doc.data() as Map<String, dynamic>;
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }
}
