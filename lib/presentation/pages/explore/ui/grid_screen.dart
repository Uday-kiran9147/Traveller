// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
    // TODO: implement initState
    getcount();
    super.initState();
  }

  getcount() async {
    
    Stream<QuerySnapshot<Map<String, dynamic>>> docs = await FirebaseFirestore.instance
        .collection("posts")
        .orderBy("date", descending: true)
        .snapshots()
        ;
    docs.forEach((element) {
      setState(() {
        collectioncount = element.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<Post> _postCollection=
    return Scaffold(
      backgroundColor: Colors.white24,
      body: Container(
          // margin: EdgeInsets.all(12),
          child: GridView.custom(
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                repeatPattern: QuiltedGridRepeatPattern.inverted,
                pattern: [
                  QuiltedGridTile(2, 2),
                  QuiltedGridTile(1, 1),
                  QuiltedGridTile(1, 1),
                  QuiltedGridTile(1, 2),
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
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong'));
                      }
                      List<DocumentSnapshot> documents = snapshot.data!.docs;
                      if (documents.isEmpty) {
                        return const Center(child: Text('No posts yet'));
                      }
                      final data =
                          documents[index].data() as Map<String, dynamic>;
                      return AspectRatio(
                        aspectRatio: 16/9,
                        child: Image.network(data["imageurl"]),
                        // post: Post(
                        //     id: data['id'],
                        //     username: data["username"],
                        //     imageURL: data["imageurl"],
                        //     description: data["description"],
                        //     userID: data["userid"],
                        //     location: data["location"],
                        //     date: data["date"]),
                      );
                    }),
              ))),
    );
  }
}
