import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/config/theme/apptheme.dart';
import 'package:traveler/domain/usecases/incrememt_reputation.dart';
import 'package:traveler/presentation/pages/explore/ui/widgets/comment_Box.dart';
import 'package:traveler/presentation/pages/home/cubit/home_cubit_cubit.dart';
import 'package:traveler/utils/routes/route_names.dart';
import '../../../../../domain/models/post.dart';
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
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
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
              icon: const Icon(Icons.more_vert),
            ),
            leading: GestureDetector(
              onTap: () {
                if (post.userID == owner) {
                  Navigator.pushNamed(context, RouteName.profilescreen,
                      arguments: null);
                } else {
                  Navigator.pushNamed(context, RouteName.profilescreen,
                      arguments: post.userID);
                }
              },
              child: CircleAvatar(
                child: Text(post.username.toUpperCase().substring(0, 2)),
              ),
            ),
            title: Row(
              children: [
                Text(
                  post.username,
                  overflow: TextOverflow.clip,
                ),
                Container(
                  height: 15,
                  width: 15,
                  decoration: const BoxDecoration(
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
                      border: Border.all(color: Colors.grey),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(post.imageURL))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Colwidget("", Icons.chat_bubble_outline_rounded),
                      onTap: () {
                        showModalBottomSheet(
                          isDismissible: true,
                          enableDrag: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          backgroundColor: AThemes.primaryBackgroundLight,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Colwidget("", Icons.share_rounded),
                    ),
                    GestureDetector(
                      onTap: () async {
                        IncrementReputation incr = IncrementReputation(post.id);
                        await incr.incrementReputation();
                        await BlocProvider.of<HomeCubitCubit>(context,
                                listen: false)
                            .state
                            .getuser();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Colwidget(convertToKNotation(post.popularity),
                            Icons.favorite_border_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "  ${post.description!}",
            ),
          ),
          const Divider(color: Color.fromARGB(255, 210, 208, 208),),
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
      return '${result.substring(0, result.length - 2)}k';
    } else {
      return '${result}k';
    }
  } else if (number >= 1000000 && number < 1000000000) {
    double value = number / 1000000;
    String result = value.toStringAsFixed(1);
    if (result.endsWith('.0')) {
      return '${result.substring(0, result.length - 2)}M';
    } else {
      return '${result}M';
    }
  } else if (number >= 1000000000) {
    double value = number / 1000000000;
    String result = value.toStringAsFixed(1);
    if (result.endsWith('.0')) {
      return '${result.substring(0, result.length - 2)}B';
    } else {
      return '${result}B';
    }
  }
  return number.toString();
}
