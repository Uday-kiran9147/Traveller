import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traveler/domain/models/user.dart';
import 'package:traveler/domain/repositories/authentication.dart';
import 'package:traveler/domain/repositories/database.dart';

import '../../../../domain/models/post.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _captionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _captionController.dispose();
    _locationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_image != null)
                Expanded(
                  child: Image.file(
                    scale: 1.0,
                    _image!,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
              // PickImage(image: _image),
              ElevatedButton(
                onPressed: _getImage,
                child: Text('Select Image'),
              ),
              TextFormField(
                controller: _captionController,
                decoration: InputDecoration(
                  labelText: 'write a caption.....',
                ),
                validator: (value) {
                  // if (value == null || value.isEmpty) {
                  //   return 'Please enter your name';
                  // }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'location (Ladhak, India)',
                ),
                validator: (value) {
                  // if (value == null || value.isEmpty) {
                  //   return 'Please enter your email';
                  // }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, process the data
                      if (_image != null) {
                        print("pressed");
                        // Use the selected image
                        // TODO: Process the image
                        bool isposted = await GoogleAuth.postUserPost(
                            Post(
                                id: "id",
                                username: "username",
                                imageURL: "imageURL",
                                description: _captionController.text,
                                userID: "userid",
                                location: _locationController.text,
                                date: DateTime.now().toString()),
                            _image!);
                        if (isposted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Form submitted')),
                          );
                          Navigator.pop(context);
                        }
                      }
                      // Reset the form
                      // _formKey.currentState!.reset();
                      // _captionController.clear();
                      // _locationController.clear();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
