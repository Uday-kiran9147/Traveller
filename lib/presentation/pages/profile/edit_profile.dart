// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traveler/data/repository/database.dart';
import 'package:traveler/domain/usecases/edit_profile.dart';
import 'package:traveler/presentation/pages/home/cubit/home_cubit_cubit.dart';
import 'package:traveler/presentation/pages/profile/cubit/profile_cubit.dart';
import 'package:traveler/presentation/widgets/snackbars.dart';

class UserInfoForm extends StatefulWidget {
  const UserInfoForm({super.key});

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

  @override
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
      imageQuality: 70,
      maxWidth: 250,
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
        title: const Text('Edit Profile'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _image != null || imageurl == null
                      ? _image != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(_image!),
                            )
                          : CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue.shade100,
                              child: Icon(
                                Icons.person_2_outlined,
                                size: 40,
                                color: Colors.blue.shade500,
                              ),
                            )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(imageurl!),
                        ),
                  IconButton.outlined(
                    onPressed: _getImage,
                    icon: const Icon(Icons.edit),
                  ),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue),
                      ),
                      onPressed: () async {
                        if (_image != null) {
                          customSnackbarMessage("updating please wait..... ",
                              context, Colors.orange);
                          await EditProfile.saveprofilepicture(_image!)
                              .then((value) async {
                            if (value) {
                              await BlocProvider.of<HomeCubitCubit>(context,
                                      listen: false)
                                  .state
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
                      child: const Text('save image'))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 300,
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                        controller: username,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'tag'),
                        controller: tag,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'bio'),
                        controller: bio,
                      ),
                    ),
                  ],
                ),
              ),
              // Add more text fields for other user information here.

              const SizedBox(height: 16),
              ElevatedButton(
                key: const Key('submit'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Save the user information to your database or use it as needed.
                    var response = await BlocProvider.of<ProfileCubit>(context)
                        .editProfile(username.text, bio.text, tag.text);
                    if (response) {
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
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
