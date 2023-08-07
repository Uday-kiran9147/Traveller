import 'package:flutter/material.dart';
import 'package:traveler/data/datasources/local/travel_story.dart';
import 'package:traveler/domain/models/travel_story.dart';
import 'package:traveler/presentation/pages/home/ui/widgets/swiperwidget.dart';

class AddStory extends StatelessWidget {
  AddStory({super.key});
  ScrollController scrollController = ScrollController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _storyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  var newstory = TravelStory(
                      uid: 'k',
                      userName: 'Uday-kiran9147',
                      storyTitle: _titleController.text,
                      travelStory: _storyController.text,
                      destinationRating: 4,
                      photos: [netimage[3], netimage[2]]);
                      travel_List.add(newstory);
                  print(_titleController.text);
                  print(_storyController.text);
                },
                icon: Icon(Icons.save))
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _titleController,
                autocorrect: true,
                onSaved: (newVal) {
                  _titleController.text = newVal!;
                },
                cursorColor: Colors.purple,
                // maxLength: 50, // max length of the text
                decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText: "story Title",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onSaved: (newVal) {
                  _storyController.text = newVal!;
                },
                scrollController: scrollController,
                controller: _storyController,
                autocorrect: true,
                cursorColor: Colors.purple,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Add Story",
                ),
              ),
            ),
          ],
        ));
  }
}
