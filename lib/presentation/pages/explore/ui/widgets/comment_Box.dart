// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:traveler/domain/models/post.dart';
import 'package:traveler/domain/usecases/add_comment.dart';

// ignore: must_be_immutable
class CommentBox extends StatelessWidget {
  final TextEditingController _commentController = TextEditingController();

  final Post post;
  CommentBox({
    Key? key,
    required this.post,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.only(top: 20),
            height: 80,
            width: 500,
            margin: const EdgeInsets.only(left: 20),
            child: TextFormField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: "Add a comment",
                suffixIcon: IconButton(
                  onPressed: () async {
                    if (_commentController.text.isNotEmpty) {
                      AddComment addComment = AddComment(
                          comment: _commentController.text, postid: post.id);
                      _commentController.clear();

                      await addComment.addComment();
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ),
            )),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("comments")
                .where("postID", isEqualTo: post.id)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center();
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              List<DocumentSnapshot> documents = snapshot.data!.docs;
              if (documents.isEmpty) {
                return const Center(child: Text('No comments yet'));
              }
              return Expanded(
                child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final data =
                          documents[index].data() as Map<String, dynamic>;
                      return ListTile(
                        onLongPress: () async {
                          if (data['userID'] ==
                              FirebaseAuth.instance.currentUser!.uid) {
                            DocumentReference<Map<String, dynamic>> id =
                                FirebaseFirestore.instance
                                    .collection("comment")
                                    .doc(data['id']);
                            await id.delete();
                          }
                        },
                        leading: const CircleAvatar(),
                        title: Text("${data['username']}"),
                        subtitle: Text(
                          data['comment'],
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.black),
                        ),
                      );
                    }),
              );
            }),
      ],
    );
  }
}
