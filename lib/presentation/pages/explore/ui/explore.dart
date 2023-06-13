import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:traveler/presentation/pages/explore/bloc/explore_bloc_bloc.dart';
import 'package:traveler/utils/routes/route_names.dart';

import '../../../../domain/models/post.dart';
import 'widgets/post_tile.dart';

class ExploreScreen extends StatefulWidget {
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  ExploreBloc expbloc = ExploreBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Explore'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }
              List<DocumentSnapshot> documents = snapshot.data!.docs;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final data = documents[index].data() as Map<String, dynamic>;

                  return PostTile(
                    post: Post(
                        id: data['id'],
                        username: data["username"],
                        imageURL: data["imageurl"],
                        description: data["description"],
                        userID: data["userid"],
                        location: data["location"],
                        date: data["date"]),
                  );
                },
                itemCount: documents.length,
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteName.newpost);
          },
          child: const Icon(Icons.add),
        ));
  }
}
