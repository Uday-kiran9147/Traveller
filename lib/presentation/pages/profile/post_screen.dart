// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import '../../../domain/models/post.dart';
import '../../../utils/routes/route_names.dart';
import '../../widgets/dialogs.dart';
import '../explore/ui/widgets/comment_Box.dart';

class PostScreen extends StatefulWidget {
  PostScreen({
    Key? key,
    required this.post,
  }) : super(key: key);
  final Post post;
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    Post post = widget.post;
    return Scaffold(
        body: Column(children: [
      ListTile(
        trailing: IconButton(
          onPressed: () {
            showBottomSheetCustom(context, post.description!, post.id);
          },
          icon: Icon(Icons.more_vert),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, RouteName.profilescreen);
          },
          child: CircleAvatar(
            child: Text(post.username.toUpperCase().substring(0, 2)),
          ),
        ),
        title: Row(
          children: [
            Text(
              post.username + "",
              overflow: TextOverflow.clip,
            ),
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(
                  "assets/verified.png",
                ),
              )),
            )
          ],
        ),
        subtitle: Text(post.location!),
      ),
      Container(
        height: 400,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            image: DecorationImage(
                fit: BoxFit.fitWidth, image: NetworkImage(post.imageURL))),
      ),
      Divider(
        thickness: 1,
      ),
      Row(
        children: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite_border,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  isDismissible: true,
                  enableDrag: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  backgroundColor: Theme.of(context).canvasColor,
                  context: context,
                  builder: (context) {
                    return CommentBox(
                      post: Post(
                          id: post.id,
                          username: post.username,
                          imageURL: post.imageURL,
                          description: post.description,
                          userID: post.userID,
                          location: post.location,
                          date: post.date),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.comment,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.share,
                color: Colors.black,
              )),
          Spacer(),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.bookmark_border,
                color: Colors.black,
              )),
        ],
      ),
      Divider(
        thickness: 1,
      ),
      Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            Text(
              post.username + " ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(post.description!),
          ],
        ),
      ),
    ]));
  }
}
