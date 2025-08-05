// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traveler/domain/usecases/upload_story.dart';
import 'package:traveler/presentation/pages/auth/ui/widgets/loginform.dart';
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
      imageQuality: 80,
      maxWidth: 600,
    );
    if (selectedImages != null) {
      setState(() {
        _images.addAll(selectedImages.map((x) => File(x.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(16);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Story',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Tooltip(
              message: "Upload story",
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  elevation: 0,
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.send_rounded, size: 20),
                label: const Text('Post'),
                onPressed: () async {
                  if (_titleController.text.isEmpty || _storyController.text.isEmpty) {
                    customSnackbarMessage('Please share something', context, Colors.orange);
                    return;
                  }
                  var user = BlocProvider.of<HomeCubitCubit>(context, listen: false).state;
                  UploadTravelStory story = UploadTravelStory(
                    userName: user.user.username,
                    userid: user.user.uid,
                    storyTitle: _titleController.text,
                    created_at: DateTime.now().toString(),
                    travelStory: _storyController.text,
                    destinationRating: _rating,
                    photos: _images,
                  );
                  await story.uploadStory().then((value) {
                    if (value) {
                      customSnackbarMessage('Story uploaded successfully', context, Colors.green);
                      Navigator.pop(context);
                    } else {
                      customSnackbarMessage('Failed to upload story', context, Colors.red);
                    }
                  }).catchError((e) {
                    customSnackbarMessage(e.toString(), context, Colors.red);
                  });
                },
              ),
            ),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.28,
                maxHeight: MediaQuery.of(context).size.height * 0.32,
              ),
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
              ),
              child: _images.isNotEmpty
                  ? Stack(
                      children: [
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.file(
                                      _images[index],
                                      fit: BoxFit.cover,
                                      width: 160,
                                      height: 180,
                                    ),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(index),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close, color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: FloatingActionButton.small(
                            heroTag: 'addImage',
                            backgroundColor: Colors.blue.shade600,
                            onPressed: _pickImages,
                            child: const Icon(Icons.add_a_photo, color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: GestureDetector(
                        onTap: _pickImages,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blue.shade200, width: 3),
                            color: Colors.blue.shade50,
                          ),
                          child: const Icon(
                            Icons.image_search_rounded,
                            color: Colors.blueGrey,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 18.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFieldCustom(
                icon: Icons.title_rounded,
                controller: _titleController,
                hint: "Title of your story...",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(12),
                child: TextFormField(
                  scrollController: scrollController,
                  controller: _storyController,
                  autocorrect: true,
                  cursorColor: theme.primaryColor,
                  maxLines: 7,
                  minLines: 5,
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: "Story",
                    hintText: "Write about your travel experience...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18.0),
            Row(
              children: [
                Text(
                  'Rating',
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.blue.shade700, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 10),
                Icon(Icons.star_rounded, color: Colors.amber.shade700, size: 22),
                Text(
                  '${_rating.toStringAsFixed(1)}/5',
                  style: theme.textTheme.titleSmall?.copyWith(color: Colors.blue.shade700),
                ),
              ],
            ),
            Slider(
              value: _rating,
              min: 0,
              max: 5,
              divisions: 10,
              label: _rating.toStringAsFixed(1),
              activeColor: Colors.amber.shade700,
              inactiveColor: Colors.grey.shade300,
              onChanged: (value) => setState(() => _rating = value),
            ),
            const SizedBox(height: 10),
            if (_images.isEmpty)
              Center(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: const Text('Pick Images'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _pickImages,
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
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
        fillColor: Colors.blue.shade50,
        filled: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
