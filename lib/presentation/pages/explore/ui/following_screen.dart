import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/presentation/pages/explore/ui/newpost_screen.dart';
import 'package:traveler/presentation/pages/home/ui/home_screen.dart';
import 'package:traveler/presentation/widgets/snackbars.dart';
import '../../../../domain/models/post.dart';
import '../cubit/explore_cubit.dart';
import 'widgets/post_tile.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final Stream<QuerySnapshot> _poststream = FirebaseFirestore.instance
      .collection("posts")
      .orderBy("date", descending: true)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExploreCubit, ExploreState>(
      listenWhen: (previous, current) => current is ExploreActionState,
      buildWhen: (previous, current) => current is! ExploreActionState,
      listener: (context, state) {
        if (state is PostPostingSuccessState) {
          customSnackbarMessage(
              'Post uploaded successfully', context, Colors.green);
          print("success and poped");
          Navigator.of(context).pop();
        }
        if (state is NavigateToNewPostScreenActionState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewPostScreen(),
              ));
        }
        if (state is PostPostingFailedState) {
          customSnackbarMessage('Something went wrong please try again later',
              context, Colors.red);
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case NavigateToNewPostScreenActionState:
            return const NewPostScreen();
          case PostingLoadingState:
            return const Scaffold(body: Center(child: LoadingProgress()));
          case ExploreInitialState:
            return Container(
                // backgroundColor: AThemes.universalcolor,
                child: StreamBuilder<QuerySnapshot>(
                    stream: _poststream,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data.toString().isEmpty) {
                        return const Center(child: Text('No posts yet'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: LoadingProgress());
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
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final data =
                              documents[index].data() as Map<String, dynamic>;

                          return GestureDetector(
                            child: PostTile(
                              post: Post(
                                  popularity: data["popularity"],
                                  id: data['id'],
                                  username: data["username"],
                                  imageURL: data["imageurl"],
                                  description: data["description"],
                                  userID: data["userid"],
                                  location: data["location"],
                                  date: data["date"]),
                            ),
                          );
                        },
                        itemCount: documents.length,
                      );
                    }),
                );

          default:
            return const Placeholder();
        }
      },
    );
  }
}
