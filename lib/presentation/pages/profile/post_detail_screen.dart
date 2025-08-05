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
  const PostScreen({
    Key? key,
    required this.post,
  }) : super(key: key);
  final Post post;
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  double imageRatioHeight = 0.0;
  double imageRatioWidth = 0.0;

  @override
  void initState() {
    super.initState();
    getImageRatio();
  }

  void getImageRatio() {
    Image image = Image.network(widget.post.imageURL);

    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        setState(() {
          imageRatioHeight = info.image.height.toDouble();
          imageRatioWidth = info.image.width.toDouble();
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final isOwner = post.userID == FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black87),
              onPressed: () {
                showBottomSheetCustom(context, post.description!, post.id);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.profilescreen,
                      arguments: post.userID);
                },
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade200,
                  child: Text(
                    post.username.toUpperCase().substring(0, 2),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
              ),
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      post.username,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (true)
                    Container(
                      height: 18,
                      width: 18,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/verified.png"),
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Text(
                post.location ?? '',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ),
            AspectRatio(
              aspectRatio: imageRatioWidth != 0 && imageRatioHeight != 0
                  ? imageRatioWidth / imageRatioHeight
                  : 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  post.imageURL,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  IconText(
                    post: post,
                    icon: Icons.favorite_border,
                    iconcolor: Colors.red,
                    icontext: post.popularity.toString(),
                    ontap: () async {
                      IncrementReputation incr = IncrementReputation(post.id);
                      await incr.incrementReputation();
                      await BlocProvider.of<HomeCubitCubit>(context, listen: false)
                          .state
                          .getuser();
                    },
                  ),
                  const SizedBox(width: 16),
                  IconText(
                    post: post,
                    icon: Icons.mode_comment_outlined,
                    iconcolor: Colors.blueGrey,
                    icontext: post.comments.length.toString(),
                    ontap: () {
                      showModalBottomSheet(
                        isDismissible: true,
                        enableDrag: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        backgroundColor: AppTheme.backgroundLight,
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
                              date: post.date,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  IconText(
                    post: post,
                    icon: Icons.share,
                    iconcolor: Colors.black87,
                    icontext: "",
                    ontap: () {},
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_border,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1, height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${post.username}: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      post.description ?? '',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class IconText extends StatelessWidget {
  const IconText({
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
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: ontap,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          border: Border.all(color: iconcolor.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.07),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconcolor, size: 22),
            if (icontext.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  icontext,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
