import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Set background color to transparent
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('static/images/bg.png'), // Replace 'assets/background.jpg' with your image asset path
            fit: BoxFit.cover, // Set the fit property to cover the entire screen
          ),
        ),
        child: Center(
          child: Image.asset(
            'static/images/GestureSpeak.png', // LOGO HERE

            width: 75, // Set the width of the logo
            height: 75, // Set the height of the logo
            // You can also use other properties of Image.asset to customize the image
          ),
        ),
      ),
    );
  }
}
