import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traveler/domain/usecases/upload_story.dart';
import 'package:traveler/presentation/pages/home/cubit/home_cubit_cubit.dart';
import 'package:traveler/presentation/widgets/snackbars.dart';

import '../../../../config/theme/apptheme.dart';

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
        await ImagePicker().pickMultiImage(imageQuality: 70,
      maxWidth: 250,);
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
            Tooltip(message: "Upload story",
              child: IconButton(
                  onPressed: () async {
                    var user = BlocProvider.of<HomeCubitCubit>(context, listen: false).state;
                    UploadTravelStory story = UploadTravelStory(
                        userName: user.user.username,
                        userid: user.user.uid,
                        storyTitle: _titleController.text,
                        created_at: DateTime.now().toString(),
                        travelStory: _storyController.text,
                        destinationRating: null,
                        photos: _images);
                    await story.uploadStory().then((value) {
                      if (value) {
                        customSnackbarMessage(
                            'Story uploaded successfully', context, Colors.green);
                        Navigator.pop(context);
                      } else {
                        customSnackbarMessage(
                            'story uploaded successfully', context, Colors.green);
                      }
                    }).catchError((e) {
                      customSnackbarMessage(e.toString(), context, Colors.green);
                    });
                  },
                  icon: Icon(Icons.upload_rounded)),
            )
          ],
        ),
        body: ListView(padding: EdgeInsets.only(top: 26.0),
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
                          child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(20)),
                            child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(20)),child: Image.file(_images![index])),
                          ),
                        );
                      },
                    ),
                  ):
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey)),
                child: GestureDetector(
                    onTap: _pickImages,
                    child: Icon(
                      Icons.image_search_rounded,
                      color: Colors.grey,
                      size: 120,
                    )),
              ),
            ),SizedBox(height: 16.0),TextButton(onPressed: _pickImages, child: Text('choose')),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextForm(titleController: _titleController)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onSaved: (newVal) {
                  _storyController.text = newVal!;
                },
                scrollController: scrollController,
                controller: _storyController,
                autocorrect: true,
                cursorColor: Theme.of(context).primaryColor,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Tell us your story",
                  fillColor: AThemes.universalcolor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({
    super.key,
    required TextEditingController titleController,
  }) : _titleController = titleController;

  final TextEditingController _titleController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _titleController,
      autocorrect: true,
      onSaved: (newVal) {
        _titleController.text = newVal!;
      },
      cursorColor: Colors.purple,
      decoration: InputDecoration(
        hintText: "story Title",
        fillColor: AThemes.universalcolor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
