import 'package:flutter/material.dart';
import 'package:traveler/presentation/pages/auth/ui/authentication.dart';
import 'package:traveler/presentation/pages/explore/ui/explore.dart';
import 'package:traveler/presentation/pages/explore/ui/newpost.dart';
import 'package:traveler/presentation/pages/home/ui/home.dart';
import 'package:traveler/utils/routes/route_names.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.home:
        return MaterialPageRoute(builder: (context) => Home());
      case RouteName.authentication:
        return MaterialPageRoute(builder: (context) => AuthenticationScreen());
      case RouteName.explore:
        return MaterialPageRoute(builder: (context) => ExploreScreen());
        case RouteName.newpost:
        return MaterialPageRoute(builder: (context) =>NewPostScreen());
      default:
        return MaterialPageRoute(
            builder: (context) => const Scaffold(
                    body: Center(
                  child: Text("404 No Route Defined"),
                )));
    }
  }
}
