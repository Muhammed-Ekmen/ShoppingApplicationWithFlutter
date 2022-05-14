import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:shopping_app_with_flutter/pages/mainPages/introductionScreen.dart';
import 'data/router.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

/// we have been at here
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme)
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouterClass.routerMethod,
    );
  }
}

class AnimatedSplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: MediaQuery.of(context).size.height,
      splash: Image.asset(
        "lib/data/images/finalBackground.jpg",
        fit: BoxFit.fill,
      ),
      nextScreen: IntroductionPage(),
      duration: 1000,
      // splashTransition: SplashTransition.rotationTransition,
    );
  }
}