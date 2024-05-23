import 'package:flutter/material.dart';
import 'package:sign_language_app/auth/login_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sign_language_app/components/custom_button.dart';
import 'navigation/main_navigation.dart';

class GettingStartedCarousel extends StatefulWidget {
  @override
  _GettingStartedCarouselState createState() => _GettingStartedCarouselState();
}

class _GettingStartedCarouselState extends State<GettingStartedCarousel> {
  final List<String> images = [
    'static/images/image-placeholder1.png',
    'static/images/image-placeholder2.png',
    'static/images/image-placeholder3.png',
  ];

  int _currentIndex = 0;  // Current index of the carousel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('static/images/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              viewportFraction: 1,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;  // Update current index on page change
                });
              },
            ),
            items: images.map((image) {
              return Builder(
                builder: (BuildContext context) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 100.0, horizontal: 20.0),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          if (_currentIndex == images.length - 1)  // Show the button only on the last item
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                    text: 'Get Started',
                    onPressed: () {
                      Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavigationScreen()),
                    );
                  },
                ),
              ),
            ),
           
        ],
      ),
    );
  }
}