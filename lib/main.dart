import 'package:sign_language_app/screens/getting_started_carousel.dart';
import 'package:sign_language_app/screens/splash_screen.dart';
// import 'package:sign_language_app/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
  await Firebase.initializeApp();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Language App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlue,
        ),
      ),
      home: FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)), // Delay for 5 seconds

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen(); // Show the splash screen
          } else {
            return GettingStartedCarousel(); // Show the getting started carousel
          }
        },
      ),
    );
  }
}