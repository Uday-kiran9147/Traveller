// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/config/theme/apptheme.dart';
import 'package:traveler/presentation/pages/explore/ui/explore_grid_screen.dart';
import 'package:traveler/presentation/pages/home/cubit/home_cubit_cubit.dart';
import 'package:traveler/presentation/pages/profile/profile.dart';
import '../../explore/ui/following_screen.dart';
import 'home_screen.dart';

class HomeBloc extends StatefulWidget {
  const HomeBloc({super.key});

  @override
  State<HomeBloc> createState() => _HomeBlocState();
}

class _HomeBlocState extends State<HomeBloc> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubitCubit, HomeCubitState>(
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeCubitInitial:
            return const MyHome();
          default:
            return const SizedBox();
        }
      },
    );
  }
}

// ignore: must_be_immutable
class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);
  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int index = 0; // initial index of the [BottomNavigationBar] is 0.
  List<Widget> _page = [];

  @override
  void initState() {
    _page = [
      const HomeScreen(),
      // const ExploreScreen(),
      const GridScreen(),
      ProfileScreen(null),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Theme.of(context).secondaryHeaderColor,
        body: Center(
          child: Container(
            constraints:const BoxConstraints(maxWidth: 450),
            child: _page[index]),
        ),
        bottomNavigationBar: NavigationBar(key: const Key('bottom_nav_bar'),
          // selectedIconTheme:
              // IconThemeData(color: Theme.of(context).primaryColor),
          // type: BottomNavigationBarType.fixed, // shifting type creates conflict with backgroundcolor
          // iconSize: 16,
          elevation: 5,
          backgroundColor: AThemes.primaryBackgroundLight ,
          // unselectedItemColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor.withOpacity(0.5),
          selectedIndex: index,
          onDestinationSelected: (value) => setState(() {
            index = value;
          }),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            // NavigationDestination(
            //     icon: Icon(Icons.follow_the_signs_outlined),
            //     label: "following"),
            NavigationDestination(
                icon: Icon(Icons.explore), label: "explore"),
            // I got into trouble while showing the (backgroundcolor) of the [BottomNavigationBar]
            // so, I had to use type property of [BottomNavigationBar] to [BottomNavigationBarType.fixed].
            NavigationDestination(
                icon: Icon(Icons.person_2_rounded), label: "profile"),
          ],
        ));
  }
}
