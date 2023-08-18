import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:traveler/domain/usecases/upload_story.dart';
import 'package:traveler/presentation/providers/user_provider.dart';
import 'package:traveler/presentation/widgets/snackbars.dart';

// ignore: must_be_immutable
class AddStory extends StatefulWidget {
  AddStory({super.key});

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  ScrollController scrollController = ScrollController();

  TextEditingController _titleController = TextEditingController();

  TextEditingController _storyController = TextEditingController();
  List<File>? _images = [];
  Future<void> _pickImages() async {
    List<XFile>? selectedImages =
        await ImagePicker().pickMultiImage(imageQuality: 85);
    for (int i = 0; i < selectedImages.length; i++) {
      setState(() {
        _images!.add(File(selectedImages[i].path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.grey,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  var user = Provider.of<UserProvider>(context, listen: false);
                  UploadTravelStory story = UploadTravelStory(
                      userName: user.user.username,
                      userid: user.user.uid,
                      storyTitle: _titleController.text,
                      created_at: DateTime.now().toString(),
                      travelStory: _storyController.text,
                      destinationRating: 4,
                      photos: _images);
                  await story.uploadStory().then((value) {
                    if (value) {
                      customSnackbarMessage('Story uploaded successfully', context, Colors.green);
                      Navigator.pop(context);
                    } else {
                      customSnackbarMessage(
                          'story uploaded successfully', context, Colors.green);
                    }
                  }).catchError((e) {
                    customSnackbarMessage(e.toString(), context, Colors.green);
                  });
                },
                icon: Icon(Icons.save))
          ],
        ),
        body: ListView(
          children: [
            _images != null && _images!.length > 0
                ? SizedBox(
                    height: 350,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(_images![index]),
                        );
                      },
                    ),
                  )
                : Container(),
            TextButton(onPressed: _pickImages, child: Text('select')),
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
