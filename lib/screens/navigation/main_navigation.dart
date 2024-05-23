import 'package:sign_language_app/components/confirm_dialog.dart';
import 'package:sign_language_app/screens/help.dart';
import 'package:sign_language_app/screens/home.dart';
import 'package:sign_language_app/screens/profile.dart';
import 'package:sign_language_app/screens/about.dart';
import 'package:flutter/material.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key});

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;
  late DateTime currentBackPressTime;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HelpScreen(),
    const AboutScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentBackPressTime = DateTime.now();
  }

  Future<bool> _onBackPressed() async {
    return showDialog(
      context: context,
      builder: (context) => const ConfirmDialog(
        titleText: 'Confirm Exit',
        contentText: 'Are you sure you want to exit?',
      ),
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar:
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: const Color(0xFF90C4EA),
            backgroundColor: const Color(0xFFFFFBD8),
            selectedLabelStyle: const TextStyle(fontFamily: 'Poppins'), // Change font style to Poppins
            unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'), // Change font style to Poppins
            selectedFontSize: 12, // Make selected label font size bigger
            unselectedFontSize: 12, // Make unselected label font size bigger
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    'static/images/home.png',
                    width: 24,
                    height: 24,
                    color: _currentIndex == 0 ? const Color(0xFF90C4EA) : Colors.black54,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    'static/images/guide.png',
                    width: 24,
                    height: 24,
                    color: _currentIndex == 1 ? const Color(0xFF90C4EA) : Colors.black54,
                  ),
                ),
                label: 'Guide',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    'static/images/info.png',
                    width: 24,
                    height: 24,
                    color: _currentIndex == 2 ? const Color(0xFF90C4EA) : Colors.black54,
                  ),
                ),
                label: 'About',
              ),
            ],
          ),
        ),
    );
  }
}
