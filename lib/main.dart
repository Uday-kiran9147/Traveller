import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:traveler/app/responsive.dart';
import 'package:traveler/config/theme/apptheme.dart';
import 'package:traveler/presentation/pages/auth/cubit/auth_cubit_cubit.dart';
import 'package:traveler/presentation/pages/auth/ui/authentication.dart';
import 'package:traveler/presentation/pages/auth/ui/web_auth.dart';
import 'package:traveler/presentation/pages/explore/cubit/explore_cubit.dart';
import 'package:traveler/presentation/pages/home/cubit/home_cubit_cubit.dart';
import 'package:traveler/presentation/pages/home/ui/home.dart';
import 'package:traveler/presentation/pages/profile/cubit/profile_cubit.dart';
import 'package:traveler/utils/constants/sharedprefs.dart';
import 'package:traveler/utils/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyA4nhUPA-B_8q8e_jcBJXMA4vkntbke638",
            appId: "1:1075481555757:web:8abaa2cf364cd6947d19a4",
            messagingSenderId: "1075481555757",
            projectId: "traveller-fd5a3",
            storageBucket: "traveller-fd5a3.appspot.com"));
  } else {
    await Firebase.initializeApp();
  }
await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
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
    getuserLoggedinStatus();
    super.initState();
  }

  getuserLoggedinStatus() async {
    SHP.getUserLoggedinStatusSP().then((value) {
      setState(() {
        isloggedin = value;
      });
    });

    if (isloggedin == null) {
      setState(() {
        isloggedin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<AuthCubitCubit>(create: (_) => AuthCubitCubit()),
        BlocProvider<HomeCubitCubit>(create: (_) => HomeCubitCubit()),
        BlocProvider<ExploreCubit>(create: (_) => ExploreCubit()),
        BlocProvider<ProfileCubit>(create: (_) => ProfileCubit()),
      ],
      child: MaterialApp(
          theme: ThemeData(
            // Define the default brightness and colors.
            // brightness: Brightness.dark,
            useMaterial3: true,
            //splash color is a color that appears behind a button's label when the button is tapped.
            splashColor: AThemes.mainTheme,colorScheme:ColorScheme.light(
              primary: AThemes.mainThemeDark,
              // primaryVariant: AThemes.mainThemeDark,
              secondary: AThemes.mainTheme,
              // secondaryVariant: AThemes.universalcolorlight,
              surface: Colors.white,
              background: AThemes.mainTheme,
              error: Colors.red,
              onPrimary: Colors.white,
              onSecondary: Colors.black,
              onSurface: Colors.black,
              onBackground: Colors.black,
              onError: Colors.white,
              brightness: Brightness.light,
            ),
            /* This sample creates a MaterialApp with a Theme whose ColorScheme is based on Colors.blue, but with the color scheme's ColorScheme.secondary color overridden to be green. The AppBar widget uses the color scheme's ColorScheme.primary as its default background color and the FloatingActionButton widget uses the color scheme's ColorScheme.secondary for its default background. By default, the Text widget uses TextTheme.bodyMedium, and the color of that TextStyle has been changed to purple. */
            // textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.purple)),

            // Define the default font family.
            fontFamily: 'roboto',

            // Define the default `TextTheme`. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            textTheme: const TextTheme(
              // ref: https://api.flutter.dev/flutter/material/TextTheme-class.html
              displayLarge: TextStyle(
                  fontSize: 72.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              titleLarge: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.black),
              bodySmall: TextStyle(fontSize: 12.0, color: Colors.black),
              bodyMedium: TextStyle(fontSize: 15.0, color: Colors.black),
              bodyLarge: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          ),scrollBehavior: const ScrollBehavior(),
          home: ResponsiveLayout(
              webS: const WebAuth(),
              mobileS: isloggedin != true?  const AuthenticationScreen():  const HomeBloc()),
          debugShowCheckedModeBanner: false,

          // this troubled me a lot
          // initialRoute: isloggedin! ? RouteName.home : RouteName.authentication,
          onGenerateRoute: AppRoutes.generateRoute),
    );
  }
}
