// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
// import 'package:traveler/domain/models/travel_story.dart';
// import 'package:traveler/presentation/pages/home/ui/story_detail_screen.dart';

import '../home_screen.dart';

class SwiperWidget extends StatelessWidget {
  SwiperWidget({
    super.key,
  });
Stream<QuerySnapshot> _travelpoststream = FirebaseFirestore.instance
      .collection("travelstory")
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return 
    StreamBuilder<QuerySnapshot>(
       stream: _travelpoststream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data.toString().isEmpty) {
              return const Center(child: Text('No posts yet'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingProgress());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }
            List<DocumentSnapshot> documents = snapshot.data!.docs;
            if (documents.isEmpty) {
              return const Center(child: Text('No posts yet'));
            }
          return Swiper(scrollDirection: Axis.horizontal,
              scale: 0.9,
              viewportFraction: 0.8,
              pagination: SwiperPagination(),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var storyItem = documents[index].data() as Map<String, dynamic>;
                print(storyItem['id']);
                return Text("storyItem['storyTitle']");
              });
        });
  }
}


/* 
GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryDetail(
                              travelStory: TravelStory(
                                  id: storyItem['id'],
                                  uid: storyItem['uid'],
                                  userName: storyItem['userName'],
                                  storyTitle: storyItem['storyTitle'],
                                  created_at: storyItem['created_at'],
                                  likes: storyItem['likes'],
                                  photos: storyItem['photos'],
                                  travelStory: storyItem['travelStory'],
                                  destinationRating:
                                      storyItem['destinationRating'])),
                        ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey,
                    ),
                    width: 76,
                    height: 110,
                    margin: EdgeInsets.all(10),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                            child: storyItem['photos'].length == 0
                                ? Container(
                                    // child: Text(index.toString()),
                                  )
                                : Image.network(storyItem['photos'][0],
                                    fit: BoxFit.cover)),
                        Positioned(
                            top: 20,
                            left: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 250,
                                  height: 150,
                                  child: Text(
                                    storyItem['storyTitle'],
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                  ),
                                ),
                                Text(storyItem['userName']),
                              ],
                            )),
                      ],
                    ),
                  ),
                );
 */