import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:traveler/domain/repositories/database.dart';
import 'package:traveler/presentation/providers/user_provider.dart';
import 'package:traveler/presentation/widgets/snackbars.dart';

class UserInfoForm extends StatefulWidget {
  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController username = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController tag = TextEditingController();
  String? imageurl;
  DatabaseService db = DatabaseService();

  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      setState(() {
        username.text = snapshot.get('username');
        bio.text = snapshot.get('bio');
        tag.text = snapshot.get('tag');
        imageurl = snapshot.get('profileurl');
      });
    }
  }

  File? _image;
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 400,
    );
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  void dispose() {
    username.dispose();
    bio.dispose();
    tag.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _image != null || imageurl == null
                      ? _image != null
                          ? CircleAvatar(
                              radius: 50, backgroundImage: FileImage(_image!))
                          : CircleAvatar(
                              backgroundImage: AssetImage('assets/noimage.png'),
                              radius: 50)
                      : CircleAvatar(
                          radius: 50, backgroundImage: NetworkImage(imageurl!)),
                  IconButton.outlined(
                      onPressed: _getImage, icon: Icon(Icons.edit)),
                  TextButton(
                      onPressed: () async {
                        if (_image != null) {
                          customSnackbarMessage("updating please wait..... ",
                              context, Colors.orange);
                          await DatabaseService.saveprofilepicture(_image!)
                              .then((value) async {
                            if (value) {
                              await Provider.of<UserProvider>(context,
                                      listen: false)
                                  .getuser();
                              customSnackbarMessage("Profile image updated ",
                                  context, Colors.green);
                            } else {
                              customSnackbarMessage(
                                  "Something went wrong, Try again",
                                  context,
                                  Colors.redAccent);
                            }
                          });
                        } else {}
                      },
                      child: Text('save image'))
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
                controller: username,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'tag'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an tag';
                  }
                  // You can add email format validation if needed.
                  return null;
                },
                controller: tag,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'bio'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a boi';
                  }
                  return null;
                },
                controller: bio,
              ),
              // Add more text fields for other user information here.

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Save the user information to your database or use it as needed.
                    var response =
                        await db.editPtofile(username.text, bio.text, tag.text);
                    if (response) {
                      await Provider.of<UserProvider>(context, listen: false)
                          .getuser();
                      Navigator.pop(context);
                      customSnackbarMessage("success!", context, Colors.green);
                    } else {
                      customSnackbarMessage(
                          "Something went wrong Try Again".toString(),
                          context,
                          Colors.red);
                    }
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
