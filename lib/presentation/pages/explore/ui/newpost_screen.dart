// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:traveler/config/theme/apptheme.dart';
import 'package:traveler/domain/usecases/save_post.dart';
import 'package:traveler/presentation/pages/auth/ui/widgets/loginform.dart';
import 'package:traveler/presentation/pages/explore/cubit/explore_cubit.dart';
import 'package:traveler/presentation/pages/home/ui/home_screen.dart';
import 'package:traveler/presentation/widgets/snackbars.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 600,
    );
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  bool waitingforlocation = false;
  Position? _currentPosition;
  String? address;
  String? fulladdress;
  bool isloading = false;

  Future<List<Placemark>> getaddressfromlatlong(Position position) async {
    List<Placemark>? placelist;
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      placelist = placemarks;
      setState(() {
        address = "${place.locality}, ${place.subLocality}";
        fulladdress =
            "${place.locality}, ${place.subLocality}, ${place.administrativeArea}, ${place.country}";
        waitingforlocation = false;
      });
      return placelist;
    }).catchError((e) {
      customSnackbarMessage(e.toString(), context, Colors.redAccent);
    });
    return placelist!;
  }

  Future getCurrentPosition() async {
    final haspermission = await handleLocationPermission();
    if (!haspermission) return;
    setState(() {
      waitingforlocation = true;
    });
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      _currentPosition = position;
      await getaddressfromlatlong(_currentPosition!);
    });
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      customSnackbarMessage(
          'Location services are disabled. Please enable the services',
          context,
          const Color.fromARGB(255, 202, 122, 0));
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      customSnackbarMessage(
          'Location permissions are permanently denied, we cannot request permissions.',
          context,
          const Color.fromARGB(255, 202, 122, 0));
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create New Post',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black45,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: AppTheme.backgroundLight,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _getImage,
                    child: Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _image != null
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _image = null;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    color: Colors.grey.shade400,
                                    size: 60,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Tap to add image",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  TextFieldCustom(
                    icon: Icons.text_fields_outlined,
                    controller: _descriptionController,
                    hint: "Write a description...",
                  ),
                  const SizedBox(height: 18),
                  TextFieldCustom(
                    controller: _locationController,
                    icon: Icons.location_on_outlined,
                    hint: "Add a location...",
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.my_location,
                        color: Colors.orange.shade700,
                        size: 22,
                      ),
                      const SizedBox(width: 4),
                      TextButton(
                        onPressed: () async {
                          await getCurrentPosition();
                          if (address != null) {
                            _locationController.text = address!;
                          }
                        },
                        child: const Text(
                          "Use current location",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      if (waitingforlocation)
                        const SizedBox(width: 12),
                      if (waitingforlocation)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _image != null
                            ? Colors.green.shade600
                            : Colors.grey.shade400,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _image == null
                          ? () {
                              customSnackbarMessage(
                                  'Please select an image',
                                  context,
                                  Colors.orange);
                            }
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isloading = true;
                                });
                                await _submitPost(context);
                                setState(() {
                                  isloading = false;
                                });
                              }
                            },
                      child: isloading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              'Post',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (fulladdress != null && fulladdress!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.place, color: Colors.orange.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              fulladdress!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.orange.shade900,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitPost(BuildContext context) {
    return BlocProvider.of<ExploreCubit>(context).postingPostEvent(
        post: SavePost(
      description: _descriptionController.text,
      location: _locationController.text,
      date: DateTime.now().toString(),
      image: _image!,
    ));
  }
}
