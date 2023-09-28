// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

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
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

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
  Future<List<Placemark>> getaddressfromlatlong(Position position) async {
    /* 
     {"name":"5VFJ+PQ3","street":"5VFJ+PQ3","isoCountryCode":"IN","country":"India","postalCode":"501501","administrativeArea":"Telangana","subAdministrativeArea":"","locality":"Pargi","subLocality":"Teacher's Colony","thoroughfare":"","subThoroughfare":""}
     */
    List<Placemark>? placelist;
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      placelist = placemarks;
      setState(() {
        address = """${place.locality}, ${place.subLocality} """;
        fulladdress =
            """${place.locality}, ${place.subLocality}, ${place.administrativeArea}, ${place.country}""";
        print(json.encode(place));
      });
      setState(() {
        waitingforlocation = false;
      });
      return placelist;
      // ignore: body_might_complete_normally_catch_error
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
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        getaddressfromlatlong(_currentPosition!);
        waitingforlocation = false;
      });
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
          Color.fromARGB(255, 202, 122, 0));
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
      backgroundColor: AThemes.universalcolor,
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Container(
              height:MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  waitingforlocation ? LinearProgressIndicator() : Container(),
                  _image != null
                      ? Expanded(flex: 2,
                          child: GestureDetector(
                            onDoubleTap: () {
                              setState(() {
                                _image = null;
                              });
                            },
                            child: Image.file(
                              scale: 1.0,
                              _image!,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                          ),
                        )
                      : Expanded(flex: 2,
                          child: Center(
                              child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: GestureDetector(
                              onTap: _getImage,
                              child: Icon(
                                Icons.image_search_rounded,
                                color: Colors.grey,
                                size: 120,
                              )),
                        ))),SizedBox(height: 16.0),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: "description.....",
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),SizedBox(height: 16.0),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: "location (Ladhak, India)",
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,color: Colors.orange,),
                      TextButton(
                          onPressed:() async {await getCurrentPosition();_locationController.text=address!;},
                          child: Text("get current location")),
                    ],
                  ),
                  Center(
                    child:isloading?LoadingProgress():  Container(width: MediaQuery.of(context).size.width*0.70,
                      child:ElevatedButton(style: ButtonStyle(backgroundColor:_image!=null? MaterialStatePropertyAll(Colors.green):MaterialStatePropertyAll(Colors.grey),elevation: MaterialStateProperty.all(10),overlayColor: MaterialStateColor.resolveWith((states) => const Color.fromARGB(255, 5, 160, 11))),
                        onPressed:_image == null? null:() async {
                          if (_formKey.currentState!.validate()) {
                            // Form is valid, process the data
                            if (_image != null) {
                              setState(() {
                                isloading = true;
                              });
                            await  BlocProvider.of<ExploreCubit>(context).postingPostEvent(
                                post: SavePost(
                                description: _descriptionController.text,
                                location:_locationController.text,
                                date: DateTime.now().toString(),
                                image: _image!,
                              ));
                              setState(() {
                                isloading = false;
                              });
                            }
                          }
                        },
                        child: Text('Post'),
                      ),
                    ),
                  ),
                  Text('ADDRESS: ${address ?? ""}'),
                  Text('Full adddress: ${fulladdress ?? ""}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}