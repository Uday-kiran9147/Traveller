import 'package:flutter/material.dart';
import 'package:traveler/data/datasources/local/travel_story.dart';
import 'package:traveler/presentation/pages/home/ui/widgets/swiperwidget.dart';

import '../../../../domain/models/travel_story.dart';
import 'widgets/story_detail_screen.dart';

class StoryListScreen extends StatelessWidget {
  const StoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: travel_List.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              var l = travel_List[index];
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryDetail(
                        travelStory: TravelStory(
                            uid: l.uid,
                            userName: l.userName,
                            storyTitle: l.storyTitle,
                            created_at: l.created_at,
                            likes: l.likes,
                            photos: l.photos,
                            travelStory: l.travelStory,
                            destinationRating: l.destinationRating)),
                  ));
            },
            child: Stack(
              children: [
                SizedBox(
                  height: 5,
                ),
                _build_Card(),
                Positioned(
                  top: 30,
                  left: 30,
                  child: CircleAvatar(
                    radius: 30,
                  ),
                ),
                _build_avatar(),
                _build_Title_user(index, context)
              ],
            ),
          );
        },
      ),
    );
  }

  Positioned _build_Title_user(int index, BuildContext context) {
    return Positioned(
        left: 30,
        bottom: 30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 250,
              height: 150,
              child: Text(
                travel_List[index].storyTitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Text(travel_List[index].userName),
          ],
        ));
  }

  Positioned _build_avatar() {
    return Positioned(
      right: 30,
      top: 30,
      child: Container(
        width: 50,
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('14'), Text('Dec')],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Padding _build_Card() {
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
              child: Image.network(netimage[2], fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
