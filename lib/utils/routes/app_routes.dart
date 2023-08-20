import 'package:flutter/material.dart';
import 'package:traveler/presentation/pages/auth/ui/authentication.dart';
import 'package:traveler/presentation/pages/explore/ui/explore.dart';
import 'package:traveler/presentation/pages/home/ui/home.dart';
import 'package:traveler/presentation/pages/profile/edit_profile.dart';
import 'package:traveler/presentation/pages/profile/profile.dart';
import 'package:traveler/utils/routes/route_names.dart';

import '../../presentation/pages/home/ui/add_story_screen.dart';
class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.addstory:
      return MaterialPageRoute(builder: (context) => AddStory());
      case RouteName.home:
        return MaterialPageRoute(builder: (context) => HomeBloc());
      case RouteName.authentication:
        return MaterialPageRoute(builder: (context) => AuthenticationScreen());
      case RouteName.explore:
        return MaterialPageRoute(builder: (context) => ExploreScreen());
        // case RouteName.newpost:
        // return MaterialPageRoute(builder: (context) =>NewPostScreen());
        case RouteName.profilescreen:
        final args= settings.arguments as String;
        return MaterialPageRoute(builder: (context) =>Profile(args.toString()));
        case RouteName.editprofile:
        return MaterialPageRoute(builder: (context) =>UserInfoForm());
      default:
        return MaterialPageRoute(
            builder: (context) => const Scaffold(
                    body: Center(
                  child: Text("404 No Route Defined"),
                )));
    }
  }
}
