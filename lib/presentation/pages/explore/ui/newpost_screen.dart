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
import 'package:traveler/presentation/pages/explore/cubit/explore_cubit.dart';
import 'package:traveler/presentation/pages/home/ui/home_screen.dart';
import 'package:traveler/presentation/widgets/snackbars.dart';

// ignore: must_be_immutable
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
      imageQuality: 70,
      maxWidth: 250,
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

  // ? 3. Function gets the List of addresses from the latitude and longitude
  Future<List<Placemark>> getaddressfromlatlong(Position position) async {
    /* 
    Sample Placemark object
     {"name":"5VFJ+PQ3","street":"5VFJ+PQ3","isoCountryCode":"IN","country":"India","postalCode":"501501","administrativeArea":"Telangana","subAdministrativeArea":"","locality":"Pargi","subLocality":"Teacher's Colony","thoroughfare":"","subThoroughfare":""}
   */
    List<Placemark>? placelist;

    // Below function Returns a list of Approximate placemarks from the latitude and longitude
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      // Assigns the first placemark to place variable
      Placemark place = placemarks[0];
      placelist = placemarks;
      setState(() {
        address = """${place.locality}, ${place.subLocality} """;
        fulladdress =
            """${place.locality}, ${place.subLocality}, ${place.administrativeArea}, ${place.country}""";
        waitingforlocation = false;
      });
      return placelist;
      // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
      customSnackbarMessage(e.toString(), context, Colors.redAccent);
    });
    return placelist!;
  }

  // ? 1. Function Gets the current Position of Device
  Future getCurrentPosition() async {
    debugPrint('getCurrentPosition');
    final haspermission = await handleLocationPermission();
    if (!haspermission) return;
    setState(() {
      waitingforlocation =
          true; // Loads the progress indicator while waiting for location
    });
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      // setState(() {
        _currentPosition =
            position; // Assigns the current position to _currentPosition variable
        // waitingforlocation = false;
      // });
      await getaddressfromlatlong(_currentPosition!);
    });
  }

  // ? 2. Function Requests for location permission
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission
        permission; // permission Represents the possible Location Permission states

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    // Check if location services are enabled
    if (!serviceEnabled) {
      customSnackbarMessage(
          'Location services are disabled. Please enable the services',
          context,
          const Color.fromARGB(255, 202, 122, 0));
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator
          .requestPermission(); // Request for location permissions In Application
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }

    // If permissions are denied forever, we cannot request permissions.
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Post',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      backgroundColor: AppTheme.backgroundLight,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 450),
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.5),
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.yellow.shade200,
                        ),
                        child: _image != null
                            ? GestureDetector(
                              onDoubleTap: () {
                                setState(() {
                                  _image = null;
                                });
                              },
                              // _image != null
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  scale: 1.0,
                                  fit: BoxFit.cover,
                                  _image!,
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              ),
                            )
                            : Center(
                                child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey,width: 4)),
                              child: GestureDetector(
                                  onTap: _getImage,
                                  child: const Icon(
                                    Icons.image_search_rounded,
                                    color: Colors.grey,
                                    size: 120,
                                  )),
                            ))),
                    ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: "write something.....",
                          fillColor: Colors.blue.shade200,
                          filled: true,
                          border: const OutlineInputBorder(
                            // borderSide: BorderSide.none,
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          hintText: "location (Ladhak, India)",
                          fillColor: Colors.blue.shade200,
                          filled: true,
                          border: const OutlineInputBorder(
                            // borderSide: BorderSide.none,
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      waitingforlocation
                          ? const LinearProgressIndicator()
                          : Container(),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.orange,
                          ),
                          TextButton(
                              onPressed: () async {
                                await getCurrentPosition();
                                _locationController.text = address!;
                              },
                              child: const Text("get current location")),
                        ],
                      ),
                      Center(
                        child: isloading
                            ? const LoadingProgress()
                            : SizedBox(
                                width: MediaQuery.of(context).size.width * 0.70,
                                height: MediaQuery.of(context).size.width * 0.13,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: _image != null
                                          ? const WidgetStatePropertyAll(
                                              Colors.green)
                                          : const WidgetStatePropertyAll(
                                              Colors.black38),
                                      elevation: WidgetStateProperty.all(10),
                                      overlayColor: WidgetStateColor.resolveWith(
                                          (states) => const Color.fromARGB(255, 5, 160, 11))),
                                  onPressed: _image == null
                                      ? (){
                                        customSnackbarMessage('Please select an image', context, Colors.orange);
                                      }
                                      : () async {
                                          if (_formKey.currentState!.validate()) {
                                            // Form is valid, process the data
                                            if (_image != null) {
                                              setState(() {
                                                isloading = true;
                                              });
                                              await _submitPost(context);
                                              setState(() {
                                                isloading = false;
                                              });
                                            }
                                          }
                                        },
                                  child: Text('Post',style: Theme.of(context).textTheme.bodyLarge,),
                                ),
                              ),
                      ),
                      if (!kDebugMode) Text('ADDRESS: ${address ?? ""}'),
                      Text('location: ${fulladdress ?? ""}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitPost(BuildContext context) {
    return BlocProvider.of<ExploreCubit>(context)
      .postingPostEvent(
          post: SavePost(
          description:
          _descriptionController.text,
          location: _locationController.text,
          date: DateTime.now().toString(),
          image: _image!,
  ));
  }
}
