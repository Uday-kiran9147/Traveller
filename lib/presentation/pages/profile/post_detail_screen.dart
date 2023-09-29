// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:traveler/config/theme/apptheme.dart';
import 'package:traveler/utils/routes/route_names.dart';

import '../../../domain/models/post.dart';
import '../../../domain/usecases/incrememt_reputation.dart';
import '../../widgets/dialogs.dart';
import '../explore/ui/widgets/comment_Box.dart';
import '../home/cubit/home_cubit_cubit.dart';

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
  double imageRatio_height = 0.0;
  double imageRatio_width = 0.0;

  void initState() {
    super.initState();
    getImageRatio();
  }

  void getImageRatio() {
    Image image = Image.network(widget.post.imageURL);

    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        setState(() {
          imageRatio_height = info.image.height.toDouble();
          imageRatio_width = info.image.width.toDouble();
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    Post post = widget.post;
    return Scaffold(
        backgroundColor: AThemes.universalcolor,
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 30,
            ),
            ListTile(
              trailing: IconButton(
                onPressed: () {
                  if (post.userID == FirebaseAuth.instance.currentUser!.uid)
                    showBottomSheetCustom(context, post.description!, post.id);
                },
                icon: Icon(Icons.more_vert),
              ),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.profilescreen,
                      arguments: post.userID);
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
            InteractiveViewer(
              // boundaryMargin: const EdgeInsets.all(20.0),
              minScale: 1,
              maxScale: 5,
              child: Container(
                height: imageRatio_height < 250 ? 250 : 500,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: imageRatio_height < 250
                            ? BoxFit.fitWidth
                            : BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        image: NetworkImage(post.imageURL))),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        GestureDetector(
                            onTap: () async {
                              IncrementReputation incr =
                                  IncrementReputation(post.id);
                              await incr.incrementReputation();
                              await BlocProvider.of<HomeCubitCubit>(context)
                                  .state
                                  .getuser();
                              print("incremented");
                            },
                            child: Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                            )),
                        Text(
                          post.popularity.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    child: Column(
                      children: [
                        GestureDetector(
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
                                        popularity: post.popularity,
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
                            child: Icon(
                              Icons.comment,
                              color: Colors.purple,
                            )),
                        Text("--")
                      ],
                    ),
                  ),
                   Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(),
                        child: Column(
                          children: [
                            GestureDetector(
                                onTap: () async {},
                                child: Icon(
                                  Icons.share,
                                  color: Colors.black,
                                )),
                            Text(
                              "",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                  Spacer(),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.bookmark_border,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  Text(
                    post.username + ": ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(post.description!),
                ],
              ),
            ),
          ]),
        ));
  }
}

// Figure out Why Function reference is not working
class IconText extends StatelessWidget {
  IconText({
    Key? key,
    required this.post,
    this.ontap,
    required this.icon,
    required this.icontext,
    required this.iconcolor,
  }) : super(key: key);

  final Post post;
  final void Function()? ontap;
  final String icontext;
  final IconData icon;
  final Color iconcolor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(border: Border.all(color: iconcolor)),
      child: Container(
        child: Column(
          children: [
            GestureDetector(
                onTap: () {
                  ontap!;
                  print(icontext);
                },
                child: Icon(
                  icon,
                  color: iconcolor,
                )),
            Text(
              icontext,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
