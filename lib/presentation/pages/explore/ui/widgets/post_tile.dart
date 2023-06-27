import 'package:flutter/material.dart';
import 'package:traveler/presentation/pages/explore/ui/widgets/comment_Box.dart';
import 'package:traveler/utils/routes/route_names.dart';
import '../../../../../domain/models/post.dart';
import '../../../../widgets/dialogs.dart';

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
        // border: Border.all(color: Colors.red),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: GestureDetector(
                        child: Colwidget("",
                            Icons.chat_rounded),
                        onTap: () {
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Colwidget("120", Icons.share),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(post.imageURL))),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Rowwidget(post.location! + "     ", Icons.location_on_outlined),
              ],
            ),
          ),
          Divider(),
          Text(
            "  " + post.description!,
          )
        ],
      ),
    );
  }

  Widget Rowwidget(String text, IconData icon) {
    return Row(children: [Text(text), Icon(icon)]);
  }

  Widget Colwidget(String text, IconData icon) {
    return Column(children: [Text(text), Icon(icon)]);
  }
}
