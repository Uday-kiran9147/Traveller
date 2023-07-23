import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:traveler/domain/models/user.dart';
import '../models/post.dart';

class DatabaseService {
  // final String uidCurrentuser = FirebaseAuth.instance.currentUser!.uid;
  // DatabaseService({required this.uid});

  // referenceing collections in database
  static final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  static final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');
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

  Future<bool> follow(String userid, List random_User_Followers) async {
    final String uidCurrentuser = FirebaseAuth.instance.currentUser!.uid;

    try {
      if (random_User_Followers.contains(uidCurrentuser)) {
        await userCollection.doc(userid).update({
          'followers': FieldValue.arrayRemove([uidCurrentuser])
        });
        await userCollection.doc(uidCurrentuser).update({
          'following': FieldValue.arrayRemove([userid])
        });
      } else {
        await userCollection.doc(userid).update({
          'followers': FieldValue.arrayUnion([uidCurrentuser])
        });
        await userCollection.doc(uidCurrentuser).update({
          'following': FieldValue.arrayUnion([userid])
        });
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addTravelList(String destination) async {
    try {
      userCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({
        'upcomingtrips': FieldValue.arrayUnion([destination])
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> incrementReputation(String postid) async {
    try {
      var post = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postid)
          .get();
      // user cannot increment popularity of his own post and user reputation will not increment for his own post
      if (post['userid'] != FirebaseAuth.instance.currentUser!.uid) {
        await postCollection
            .doc(postid)
            .update({'popularity': FieldValue.increment(2)});
        await userCollection
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

  Future<bool> deleteTravelList(String destination) async {
    try {
      userCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({
        'upcomingtrips': FieldValue.arrayRemove([destination])
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editPtofile(String username, String bio, String tag) async {
    try {
      await userCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({
        "username": username,
        "bio": bio,
        "tag": tag,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future addComment(Comment comment) async {
    await userCollection.doc(comment.userID);
    // var user = await userCollection.doc(comment.userID).get();
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

  static Future saveUserData(
    String name,
    String email,
    password,
  ) async {
    UserRegister user = UserRegister(
      reputation: 0,
      bio: null,
      username: name,
      email: email,
      password: password,
      tag: null,
      upcomingtrips: [],
      profileurl: null,
      followers: [],
      following: [],
      uid: FirebaseAuth.instance.currentUser!.uid,
    );
    return await userCollection
        .doc(
          FirebaseAuth.instance.currentUser!.uid,
        )
        .set(user.toMap());
  }

  static Future<bool> saveprofilepicture(File image) async {
    try {
      final ref = await FirebaseStorage.instance.ref().child("userProfile").child(
          "Traveller-profile-${userCollection.id}-${FirebaseAuth.instance.currentUser!.uid}");
      await ref.putFile(image);
      final imageurl = await ref.getDownloadURL();
      //  DocumentReference userdocreference= await userCollection.add({});
      await userCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({
        "profileurl": imageurl.toString(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> savepost(Post post, File image) async {
    // print("database post");

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
        // final data = doc.data() as Map<String, dynamic>;
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }
}
