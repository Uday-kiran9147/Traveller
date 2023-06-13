// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../../domain/models/post.dart';

class PostTile extends StatelessWidget {
  const PostTile({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
      ),
      child: Column(
        children: [
          ListTile(
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert),
            ),
            leading: CircleAvatar(
              child: Text(post.username.toUpperCase().substring(0, 2)),
            ),
            title: Text(post.username),
            subtitle: Text(post.location!),
          ),
          Container(
            height: 400,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(post.imageURL))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Rowwidget("489  ", Icons.chat_rounded),
                Rowwidget("!  ", Icons.location_on_outlined),
                Rowwidget("435  ", Icons.share),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget Rowwidget(String text, IconData icon) {
  return Container(
    child: Row(children: [Text(text), Icon(icon)]),
  );
}
