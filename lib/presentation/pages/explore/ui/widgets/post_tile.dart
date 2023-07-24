import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveler/data/repository/database.dart';
import 'package:traveler/presentation/pages/explore/ui/widgets/comment_Box.dart';
import 'package:traveler/presentation/pages/profile/random_profile.dart';
import 'package:traveler/utils/routes/route_names.dart';
import '../../../../../domain/models/post.dart';
import '../../../../providers/user_provider.dart';
import '../../../../widgets/dialogs.dart';

// ignore: must_be_immutable
class PostTile extends StatelessWidget {
  PostTile({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;
  String owner = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    bool isowner = post.userID == owner ? true : false;

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
                isowner
                    ? showBottomSheetCustom(context, post.description!, post.id)
                    : null;
              },
              icon: Icon(Icons.more_vert),
            ),
            leading: GestureDetector(
              onTap: () {
               if(post.userID == owner){
                  Navigator.pushNamed(context, RouteName.profilescreen);
               }
               else{
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RandomProfile(uid: post.userID),
                    ));
               }
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: GestureDetector(
                        child: Colwidget("", Icons.chat_rounded),
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
                                    popularity: post.popularity,
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
                    GestureDetector(
                      onTap: () async {
                        DatabaseService db = DatabaseService();
                        await db.incrementReputation(post.id);
                        await Provider.of<UserProvider>(context, listen: false)
                            .getuser();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Colwidget(convertToKNotation(post.popularity),
                            Icons.nat_sharp),
                      ),
                    ),
                  ],
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
          Text(
            "  " + post.description!,
          ),
          Divider(),
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

String convertToKNotation(int number) {
  if (number >= 1000 && number < 1000000) {
    double value = number / 1000;
    String result = value.toStringAsFixed(1);
    if (result.endsWith('.0')) {
      return result.substring(0, result.length - 2) + 'k';
    } else {
      return result + 'k';
    }
  } else if (number >= 1000000 && number < 1000000000) {
    double value = number / 1000000;
    String result = value.toStringAsFixed(1);
    if (result.endsWith('.0')) {
      return result.substring(0, result.length - 2) + 'M';
    } else {
      return result + 'M';
    }
  } else if (number >= 1000000000) {
    double value = number / 1000000000;
    String result = value.toStringAsFixed(1);
    if (result.endsWith('.0')) {
      return result.substring(0, result.length - 2) + 'B';
    } else {
      return result + 'B';
    }
  }
  return number.toString();
}
