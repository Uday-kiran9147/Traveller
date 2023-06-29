// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:traveler/domain/models/post.dart';
import 'package:traveler/domain/repositories/authentication.dart';

// ignore: must_be_immutable
class CommentBox extends StatelessWidget {
  TextEditingController _commentController = TextEditingController();

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
            height: 70,
            width: 500,
            margin: EdgeInsets.only(left: 20),
            child: TextFormField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: "Add a comment",
                suffixIcon: IconButton(
                  onPressed: () async {
                   if(_commentController.text.isNotEmpty){
                     await GoogleAuth.addComment(Comment(
                        id: "id",
                        username: "username",
                        comment: _commentController.text,
                        userID: "",
                        date: "",
                        postID: post.id));
                   }
                  },
                  icon: Icon(Icons.send),
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
                return const Center(child: CircularProgressIndicator());
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
                        leading: CircleAvatar(),
                        title: Text("${data['username']}"),
                        subtitle: Text(data['comment'],style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),),
                      );
                    }),
              );
            }),
      ],
    );
  }
}
