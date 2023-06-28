// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/config/theme/apptheme.dart';
import 'package:traveler/presentation/pages/explore/ui/grid_screen.dart';
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
      GridScreen(),
      Profile(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _page[index],
        bottomNavigationBar: BottomNavigationBar(
          selectedIconTheme: IconThemeData(color: Theme.of(context).canvasColor),
          type: BottomNavigationBarType.fixed,
          iconSize: 16,
          elevation: 5,
          backgroundColor: AThemes.universalcolor,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Theme.of(context).primaryColor,
          currentIndex: index,
          onTap: (value) => setState(() {
            index = value;
          }),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.follow_the_signs_outlined), label: "following"),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore), label: "explore"),
                // I got into trouble while showing the (backgroundcolor) of the [BottomNavigationBar] 
                // so, I had to use type property of [BottomNavigationBar] to [BottomNavigationBarType.fixed].
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2_rounded), label: "profile"),
          ],
        ));
  }
}
