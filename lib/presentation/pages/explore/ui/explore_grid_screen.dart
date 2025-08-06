import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:traveler/presentation/pages/profile/post_detail_screen.dart';
import '../../../../domain/models/post.dart';

class GridScreen extends StatelessWidget {
  const GridScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('No posts yet'));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.custom(
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                repeatPattern: QuiltedGridRepeatPattern.mirrored,
                pattern: const [
                  QuiltedGridTile(2, 1),
                  QuiltedGridTile(2, 1),
                  QuiltedGridTile(1, 1),
                  QuiltedGridTile(1, 1),
                ],
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                (context, index) {
                  final data = docs[index].data();
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostScreen(
                          post: Post(
                            id: data['id'],
                            username: data["username"],
                            popularity: data["popularity"],
                            imageURL: data["imageurl"],
                            description: data["description"],
                            userID: data["userid"],
                            location: data["location"],
                            date: data["date"],
                          ),
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/noimage.png',
                        image: data["imageurl"],
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 40),
                        ),
                      ),
                    ),
                  );
                },
                childCount: docs.length,
              ),
            ),
          );
        },
      ),
    );
  }
}
