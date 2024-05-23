import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
 void _showFloatingCard(String title, String imagePath) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.8, // Set the height to 80% of the screen height
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 24.0),
                ),
                SizedBox(height: 16.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.6, // Set the image height to 60% of the screen height
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'American Sign Language Guide',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40.0),
            child: FilledButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                  const Size(double.infinity, 120.0),
                ),
              ),
              child: const Text(
                'Alphabet',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _showFloatingCard('Alphabet', 'static/images/asl_chart.jpg'); // Pass the image path
              },
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40.0),
            child: FilledButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                  const Size(double.infinity, 120.0),
                ),
              ),
              child: const Text(
                'Numbers',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _showFloatingCard('Numbers', 'static/images/number_chart.jpg'); // Pass the image path
              },
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40.0),
            child: FilledButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                  const Size(double.infinity, 120.0),
                ),
              ),
              child: const Text(
                'Phrases',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _showFloatingCard('Phrases', 'static/images/phrases_chart.jpg'); // Pass the image path
              },
            ),
          ),
        ],
      ),
    );
  }
}
