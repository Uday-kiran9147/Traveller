// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:traveler/presentation/pages/profile/post_screen.dart';
import '../../../../domain/models/post.dart';
import '../../home/ui/home_screen.dart';

class GridScreen extends StatefulWidget {
  GridScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<GridScreen> createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  int collectioncount = 0;
  @override
  void initState() {
    getcount();
    super.initState();
  }

  getcount() async {
    Stream<QuerySnapshot<Map<String, dynamic>>> docs = await FirebaseFirestore
        .instance
        .collection("posts")
        .orderBy("date", descending: true)
        .snapshots();
    docs.forEach((element) {
      setState(() {
        collectioncount = element.docs.length;
      });
    });
  }

  @override
  void dispose() {
    collectioncount = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List<Post> _postCollection=
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: double.maxFinite,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.greenAccent,
            Colors.purple,
          ])),
          child: GridView.custom(
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                repeatPattern: QuiltedGridRepeatPattern.mirrored,
                pattern: [
                  QuiltedGridTile(2, 1),
                  QuiltedGridTile(2, 1),
                  // QuiltedGridTile(1, 1),
                  // QuiltedGridTile(1, 1),
                ],
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                childCount: collectioncount,
                (context, index) => StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data.toString().isEmpty) {
                        return const Center(child: Text('No posts yet'));
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: LoadingProgress());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong'));
                      }
                      List<DocumentSnapshot> documents = snapshot.data!.docs;
                      if (documents.isEmpty) {
                        return const Center(child: Text('No posts yet'));
                      }
                      final data =
                          documents[index].data() as Map<String, dynamic>;
                      return InkWell(
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
                                          date: data["date"]),
                                    ))),
                        child: Image.network(
                          data["imageurl"],
                          fit: BoxFit.cover,
                        ),
                      );
                    }),
              )),
        ));
  }
}
