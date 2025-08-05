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

class PostTile extends StatelessWidget {
  final Post post;
  final String owner = FirebaseAuth.instance.currentUser!.uid;

  PostTile({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isOwner = post.userID == owner;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RouteName.profilescreen,
                    arguments: isOwner ? null : post.userID);
              },
              child: CircleAvatar(
                radius: 20,
                child: Text(
                  post.username.substring(0, 2).toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            title: Text(
              post.username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(post.location ?? ""),
            trailing: isOwner
                ? IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showBottomSheetCustom(
                          context, post.description!, post.id);
                    },
                  )
                : null,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              post.imageURL,
              width: double.infinity,
              height: 350,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              post.description ?? "No description provided",
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    backgroundColor: AppTheme.universalColor,
                    builder: (context) => CommentBox(post: post),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share_rounded),
                onPressed: () async {
                  // make share functionality commingsoon in a dialog
                 await showDialog(
                    context: context,
                    builder: (context) {
                      return ScaffoldMessenger(
                        child: AlertDialog(
                          title: const Text('Coming Soon'),
                          content: const Text(
                              'This feature is coming soon. Stay tuned!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_upward, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(convertToKNotation(post.popularity)),
                      ],
                    ),
                    onPressed: () async {
                      await IncrementReputation(post.id).incrementReputation();
                      await BlocProvider.of<HomeCubitCubit>(context, listen: false)
                          .state
                          .getuser();
                    },
                  ),
                ],
              ),
            ],
          ),
          Divider(thickness: 1,color: Colors.grey,)
        ],
      ),
    );
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
