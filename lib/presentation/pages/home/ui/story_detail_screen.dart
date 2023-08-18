// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:provider/provider.dart';
import 'package:traveler/domain/models/travel_story.dart';
import 'package:traveler/domain/usecases/delete_travelstory.dart';
import 'package:traveler/presentation/widgets/snackbars.dart';

import '../../../providers/user_provider.dart';

class StoryDetail extends StatelessWidget {
  TravelStory travelStory;
  StoryDetail({Key? key, required this.travelStory}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var curuser = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            ListView(
              children: [
                travelStory.photos.length > 0
                    ? SizedBox(
                        height: 300,
                        child: Swiper(
                          autoplay: true,
                          itemCount: travelStory.photos.length,
                          loop: false,
                          itemBuilder: (context, index) {
                            return Image.network(travelStory.photos[index]);
                          },
                        ),
                      )
                    : Container(),
                Text(travelStory.photos.length.toString()),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('@' + travelStory.userName,
                          style: Theme.of(context).textTheme.labelMedium),
                      Text(travelStory.created_at,
                          style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(travelStory.travelStory,
                      cursorHeight: 30,
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
                          color: index + 1 <= travelStory.destinationRating
                              ? Colors.amber[700]
                              : Colors.grey);
                    },
                  ),
                ),
                SizedBox(
                  height: 66,
                )
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 66,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    travelStory.uid == curuser.uid
                        ? Expanded(
                          child: IconButton(
                              onPressed: () async {
                                DeleteTravelStory deleteTravelStory =
                                    DeleteTravelStory(storyid: travelStory.id);
                                await deleteTravelStory
                                    .deleteStory()
                                    .then((value) => customSnackbarMessage(
                                        value,
                                        context,
                                        Colors.green.shade300))
                                    .catchError((e) {
                                  customSnackbarMessage(
                                        e.toString(),
                                        context,
                                        Colors.red);
                                      Navigator.pop(context);
                                });
                              },
                              icon: Icon(Icons.delete_outlined),color: Colors.red),
                        )
                        : Container(),
                    Expanded(
                      child: IconButton(
                          onPressed: () {}, icon: Icon(Icons.share_outlined),color: Colors.blue),
                    ),
                    Expanded(
                      child: IconButton(
                          onPressed: () {}, icon: Icon(Icons.comment_outlined)),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () {
                                // travelStory.likes.add('1');
                              },
                              icon: Icon(Icons.favorite_border_outlined)),
                          Text(
                            travelStory.likes.toString(),
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
