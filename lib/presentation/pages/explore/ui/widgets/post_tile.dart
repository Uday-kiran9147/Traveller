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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.profilescreen,
                      arguments: isOwner ? null : post.userID);
                },
                child: Builder(
                  builder: (context) {
                    var color = Colors.primaries[post.username.hashCode % Colors.primaries.length];
                    return CircleAvatar(
                      radius: 22,
                      backgroundColor: color.shade50,
                      child: Text(
                        post.username.substring(0, 2).toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: color,
                        ),
                      ),
                    );
                  }
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (post.location != null && post.location!.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 2),
                          Text(
                            post.location!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              if (isOwner)
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    showBottomSheetCustom(context, post.description!, post.id);
                  },
                ),
            ],
          ),
          const SizedBox(height: 10),
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.network(
                post.imageURL,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(child: Icon(Icons.broken_image, size: 48)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Description
          if (post.description != null && post.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Text(
                post.description!,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
          const SizedBox(height: 8),
          // Actions Row
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.comment_outlined, color: Colors.blueGrey),
                tooltip: "Comments",
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    backgroundColor: AppTheme.universalColor,
                    builder: (context) => CommentBox(post: post),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share_rounded, color: Colors.blueGrey),
                tooltip: "Share",
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Coming Soon'),
                        content: const Text('This feature is coming soon. Stay tuned!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const Spacer(),
              // Popularity (Upvote)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () async {
                    await IncrementReputation(post.id).incrementReputation();
                    await BlocProvider.of<HomeCubitCubit>(context, listen: false)
                        .state
                        .getuser();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_upward, color: Colors.green, size: 22),
                        const SizedBox(width: 4),
                        Text(
                          convertToKNotation(post.popularity),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey.shade300,
            thickness: 1, 
          ),
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
