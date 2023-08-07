// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:traveler/domain/models/travel_story.dart';

class StoryDetail extends StatelessWidget {
  TravelStory travelStory;
  StoryDetail({Key? key, required this.travelStory}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(travelStory.storyTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 30)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('@' + travelStory.userName,
                  style: Theme.of(context).textTheme.labelMedium),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(travelStory.travelStory,
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Rating'),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Icon(Icons.star,
                      color: index+1 <= travelStory.destinationRating
                          ? Colors.amber[700]
                          : Colors.grey);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
