// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/models/travel_story.dart';
import 'story_detail_screen.dart';

class StoryListScreen extends StatelessWidget {
  StoryListScreen({super.key});

  final Stream<QuerySnapshot> _travelstorytstream =
      FirebaseFirestore.instance.collection("travelstory").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your background color
      appBar: AppBar(
        title: const Text(
          "Travel Stories",
          style: TextStyle(
            color: Colors.black, // Customize the app bar text color
          ),
        ),
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove app bar shadow
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _travelstorytstream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          List<DocumentSnapshot> documents = snapshot.data!.docs;
          if (documents.isEmpty) {
            return const Center(child: Text('No posts yet'));
          }
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var data = documents[index].data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoryDetail(
                        travelStory: TravelStory(
                          uid: data['uid'],
                          userName: data['userName'],
                          storyTitle: data['storyTitle'],
                          created_at: data['created_at'],
                          likes: data['likes'],
                          photos: data['photos'],
                          travelStory: data['travelStory'],
                          destinationRating: data['destinationRating'],
                          id: data['id'],
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              data['photos'].isEmpty
                                  ? 'https://via.placeholder.com/400'
                                  : data['photos'][0],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['userName'],
                              style: const TextStyle(
                                color:
                                    Colors.blue, // Customize the username color
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data['storyTitle'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Posted on ${DateFormat.yMd().format(DateTime.parse(data['created_at']))}",
                              // 'Posted on ${data['created_at']}',
                              style: const TextStyle(
                                color: Colors.grey, // Customize the date color
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Positioned build_Title_username(
      int index, BuildContext context, String title, String username) {
    return Positioned(
        left: 30,
        bottom: 30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 250,
              height: 150,
              child: Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Text(username),
          ],
        ));
  }

  Positioned build_Date() {
    return Positioned(
      right: 30,
      top: 30,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('14'), Text('Dec')],
        ),
      ),
    );
  }

  Padding build_Card(String? image0) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          height: 380,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: image0 == null
                  ? Container(
                      color: Colors.grey,
                    )
                  : Image.network(image0, fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
