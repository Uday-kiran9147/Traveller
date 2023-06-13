import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/domain/models/user.dart';
import 'package:traveler/domain/repositories/authentication.dart';
import 'package:traveler/presentation/pages/auth/ui/authentication.dart';
import 'package:traveler/presentation/pages/home/ui/widgets/navbar.dart';
import 'package:traveler/utils/constants/sharedprefs.dart';
import 'package:traveler/utils/routes/route_names.dart';
import '../../explore/ui/explore.dart';
import '../bloc/home_bloc_bloc.dart';
import 'widgets/swiperwidget.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;
  HomeBlocBloc homeBlocBloc = HomeBlocBloc();

  @override
  void initState() {
    super.initState();
    homeBlocBloc.add(HomeInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBlocBloc, HomeBlocState>(
      bloc: homeBlocBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is NavigateToExploreActionState) {
          Navigator.pushNamed(context, RouteName.explore);
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeSuccessState:
            return HomeScreen(
              homeBlocBloc: homeBlocBloc,
            );
          case NavigateToExploreActionState:
            return ExploreScreen();

          default:
            return SizedBox();
        }
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeBlocBloc homeBlocBloc;
  HomeScreen({
    Key? key,
    required this.homeBlocBloc,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? email;
  @override
  void initState() {
    getuser();
    // _stream = _streamController.stream.asBroadcastStream();
    super.initState();
  }

  getuser() async {
    var getuser = await SHP.getUserEmailSP();
    setState(() {
      email = getuser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  GoogleAuth auth = GoogleAuth();
                  bool isSignout = await auth.signoutuser();
                  if (isSignout) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RouteName.authentication, (route) => false);
                  }
                },
                icon: Icon(Icons.logout))
          ],
          title: Text("$email"),
        ),
        // backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return DestinationCard(
                        destination: 'Africa $index',
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: TextField(
                        scrollPadding: EdgeInsets.all(8),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          hintText: 'search country or list',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Icon(Icons.filter_alt_outlined),
                        decoration: BoxDecoration(),
                      ),
                    )
                  ],
                ),
                Container(
                    height: 330, //392,
                    width: double.maxFinite,
                    // decoration: BoxDecoration(color: Colors.green),
                    child: SwiperWidget()),
                ElevatedButton(
                    onPressed: () {
                      widget.homeBlocBloc.add(NavigateToExploreEvent());
                    },
                    child: Text("Navigate to Explore")),
                ElevatedButton(
                    onPressed: () {
                      widget.homeBlocBloc.add(NavigateToExploreEvent());
                    },
                    child: Text("Navigate to Explore"))
              ],
            ),
          ),
        ),
        bottomNavigationBar: NavBarHome());
  }
}
