import 'dart:io';
// import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:traveler/data/repository/database.dart';

// import '../models/travel_story.dart';

class UploadTravelStory {
  final String userName;
  final String storyTitle;
  final String created_at;
  final String travelStory;
  final double destinationRating;
  List<File>? photos;

  UploadTravelStory(
      {required this.userName,
      required this.storyTitle,
      required this.created_at,
      required this.travelStory,
      required this.destinationRating,
      this.photos});
  Future<bool> uploadStory() async {
    try {
      DocumentReference travelStoryreference =
          await DatabaseService.travelStoryCollection.add({
        "userName": userName,
        "storyTitle": storyTitle,
        "created_at": created_at,
        "likes": 0,
        "travelStory": travelStory,
        "destinationRating": destinationRating,
      });

      List<String> images = [];

      if (photos != null || photos!.length > 0) {
        for (int i = 0; i < photos!.length; i++) {
          var ref = await FirebaseStorage.instance.ref().child('storypost').child(
              "Traveller-storypost${userName}-${travelStoryreference.id}${i + 1}");
          await ref.putFile(photos![i]);
          var currentImage = await ref.getDownloadURL();
          images.add(currentImage);
        }
      }
      await travelStoryreference
          .update({'id': travelStoryreference.id, 'photos': images});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
