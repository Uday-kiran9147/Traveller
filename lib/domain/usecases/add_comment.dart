import 'package:firebase_auth/firebase_auth.dart';

import '../../data/repository/database.dart';
import '../models/post.dart';

class AddComment {
  final Comment comment;

  AddComment(this.comment);

  Future<void> addComment() async {
    var getuser = await DatabaseService.userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => value['username']);
    // print(json.encode(getuser));
    await DatabaseService.addComment(Comment(
        id: "",
        username: getuser,
        comment: comment.comment,
        userID: FirebaseAuth.instance.currentUser!.uid,
        date: DateTime.now().toString(),
        postID: comment.postID));
  }
}
