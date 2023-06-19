// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/presentation/pages/explore/bloc/explore_bloc_bloc.dart';
import 'package:traveler/presentation/pages/profile/profile.dart';
import 'package:traveler/utils/routes/route_names.dart';
import '../../explore/ui/explore.dart';
import '../bloc/home_bloc_bloc.dart';
import 'home_screen.dart';

class HomeBloc extends StatefulWidget {
  @override
  State<HomeBloc> createState() => _HomeBlocState();
}

class _HomeBlocState extends State<HomeBloc> {
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
            return MyHome(homeBlocBloc: homeBlocBloc);
          default:
            return SizedBox();
        }
      },
    );
  }
}

class MyHome extends StatefulWidget {
  MyHome({
    Key? key,
    required this.homeBlocBloc,
  }) : super(key: key);
  HomeBlocBloc homeBlocBloc;
  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int index = 0;
  List<Widget> _page = [];

  @override
  void initState() {
    _page = [
      HomeScreen(homeBlocBloc: widget.homeBlocBloc),
      ExploreScreen(),
      Profile()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _page[index],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).canvasColor,
          currentIndex: index,
          onTap: (value) => setState(() {
            index = value;
          }),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded), label: "explore"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2_rounded), label: "profile"),
          ],
        ));
  }
}
