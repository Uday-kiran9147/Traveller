// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:traveler/domain/usecases/upload_story.dart';
import 'package:traveler/presentation/pages/home/cubit/home_cubit_cubit.dart';
import 'package:traveler/presentation/widgets/snackbars.dart';


// ignore: must_be_immutable
class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  ScrollController scrollController = ScrollController();

  double _rating = 0;
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _storyController = TextEditingController();
  final List<File> _images = [];
  Future<void> _pickImages() async {
    List<XFile>? selectedImages = await ImagePicker().pickMultiImage(
      imageQuality: 70,
      maxWidth: 250,
    );
    for (int i = 0; i < selectedImages.length; i++) {
      setState(() {
        _images.add(File(selectedImages[i].path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'New Story',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Tooltip(
                message: "upload story",
                child: ActionChip(
                    onPressed: () async {
                      if (_titleController.text.isEmpty ||
                          _storyController.text.isEmpty) {
                        customSnackbarMessage(
                            'Please share something', context, Colors.orange);
                        return;
                      }
                      var user = BlocProvider.of<HomeCubitCubit>(context,
                              listen: false)
                          .state;
                      UploadTravelStory story = UploadTravelStory(
                          userName: user.user.username,
                          userid: user.user.uid,
                          storyTitle: _titleController.text,
                          created_at: DateTime.now().toString(),
                          travelStory: _storyController.text,
                          destinationRating:_rating,
                          photos: _images);
                      await story.uploadStory().then((value) {
                        if (value) {
                          customSnackbarMessage('Story uploaded successfully',
                              context, Colors.green);
                          Navigator.pop(context);
                        } else {
                          customSnackbarMessage(
                              'Failed to upload story', context, Colors.red);
                        }
                      }).catchError((e) {
                        customSnackbarMessage(
                            e.toString(), context, Colors.red);
                      });
                    },
                    side: BorderSide.none,
                    backgroundColor: Colors.blue.shade200,
                    avatar: const Icon(Icons.upload_rounded),
                    label: const Text('Post')),
              ),
            )
          ],
        ),
        body: ListView(
          // padding: const EdgeInsets.all(8),
          children: [
            Container(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.5),
                margin: _images.isEmpty
                    ? const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ).copyWith(bottom: 16)
                    : null,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.yellow.shade200,
                ),
                child: _images.isNotEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    // border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20)),
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    child: Image.file(
                                        fit: BoxFit.cover, _images[index])),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue.shade200,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey, width: 4)),
                          child: GestureDetector(
                              onTap: _pickImages,
                              child: const Icon(
                                Icons.image_search_rounded,
                                color: Colors.grey,
                                size: 120,
                              )),
                        ),
                      )),
            const SizedBox(height: 16.0),
            TextButton(onPressed: _pickImages, child: const Text('choose')),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextForm(
                  controller: _titleController,
                  hintText: "Title",
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                scrollController: scrollController,
                controller: _storyController,
                autocorrect: true,
                cursorColor: Theme.of(context).primaryColor,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: "Story",
                  hintText: "write something about your travel experience",
                  fillColor: Colors.blue.shade200,
                  filled: true,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
             Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Rating ${_rating}/5',style: Theme.of(context).textTheme.headlineMedium!.copyWith(color:Colors.black )),
            ),
            Slider(
                value: _rating,
                min: 0,
                max: 5,
                divisions: 5,
                label: _rating.toString(),
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                  print(_rating);
                }),
          ],
        ));
  }
}

class CustomTextForm extends StatelessWidget {
  CustomTextForm({required this.controller, required this.hintText});

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Colors.blue.shade200,
        filled: true,
        border: const OutlineInputBorder(
          // borderSide: BorderSide.none,
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
