import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/presentation/pages/explore/bloc/explore_bloc_bloc.dart';
import 'package:traveler/presentation/pages/explore/ui/newpost.dart';
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
    expbloc.add(ExploreInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExploreBloc, ExploreState>(
      bloc: expbloc,
      listenWhen: (previous, current) => current is ExploreActionState,
      buildWhen: (previous, current) => current is! ExploreActionState,
      listener: (context, state) {
        if (state is PostPostingSuccessState) {
          Navigator.pop(context);
        }
        if (state is NavigateToNewPostScreenActionState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewPostScreen(exploreBloc: expbloc),
              ));
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case NavigateToNewPostScreenActionState:
            return NewPostScreen(
              exploreBloc: expbloc,
            );

          case ExploreInitialState:
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Explore'),
                ),
                body: StreamBuilder<QuerySnapshot>(
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
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final data =
                              documents[index].data() as Map<String, dynamic>;

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
                    expbloc.add(NavigateToNewPostScreenEvent());
                  },
                  child: const Icon(Icons.add),
                ));

          default:
            return SizedBox();
        }
      },
    );
  }
}
