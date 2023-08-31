// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:traveler/presentation/pages/profile/post_detail_screen.dart';
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
TextEditingController _searcheController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // List<Post> _postCollection=
    return Scaffold(
        backgroundColor: Color.fromARGB(229, 59, 55, 55),
        body: ListView(
          children: [
            Container(
              child: SizedBox(
                height:50,width: 70,
                child: TextFormField(controller:_searcheController ,decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search,color: Colors.grey,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white)
                  ),
                ),),
              ),
            ),
            Container(
              height: double.maxFinite,
              decoration: BoxDecoration(),
              child: GridView.custom(
                  gridDelegate: SliverQuiltedGridDelegate(
                    crossAxisCount: 4,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    repeatPattern: QuiltedGridRepeatPattern.mirrored,
                    pattern: [
                      QuiltedGridTile(2, 1),
                      QuiltedGridTile(2, 1),
                      QuiltedGridTile(1, 1),
                      QuiltedGridTile(1, 1),
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
            ),
          ],
        ));
  }
}
