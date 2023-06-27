import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:traveler/presentation/pages/auth/ui/authentication.dart';
import 'package:traveler/presentation/pages/home/ui/home.dart';
import 'package:traveler/utils/constants/sharedprefs.dart';
import 'package:traveler/utils/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isloggedin = false;
  @override
  void initState() {
    super.initState();
    getuserLoggedinStatus();
  }

  getuserLoggedinStatus() async {
    await SHP.getUserLoggedinStatusSP().then((value) {
      setState(() {
        isloggedin = value;
      });
    });

    if(isloggedin == null){
      setState(() {
        isloggedin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          // Define the default brightness and colors.
          // brightness: Brightness.dark,
          // primarySwatch:
          //splash color is a color that appears behind a button's label when the button is tapped.
          splashColor: Colors.white,
          /* This sample creates a MaterialApp with a Theme whose ColorScheme is based on Colors.blue, but with the color scheme's ColorScheme.secondary color overridden to be green. The AppBar widget uses the color scheme's ColorScheme.primary as its default background color and the FloatingActionButton widget uses the color scheme's ColorScheme.secondary for its default background. By default, the Text widget uses TextTheme.bodyMedium, and the color of that TextStyle has been changed to purple. */
          // textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.purple)),

          // Define the default font family.
          fontFamily: 'roboto',
 
          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            // ref: https://api.flutter.dev/flutter/material/TextTheme-class.html
            displayLarge:
                TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyMedium: TextStyle(fontSize: 14.0, ),
          ),
        ),
        home: isloggedin! ? HomeBloc() : AuthenticationScreen(),
        debugShowCheckedModeBanner: false,

        // this troubled me a lot
        // initialRoute: isloggedin! ? RouteName.home : RouteName.authentication,
        onGenerateRoute: AppRoutes.generateRoute);
  }
}
