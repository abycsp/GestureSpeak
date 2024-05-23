import 'package:sign_language_app/components/custom_button.dart';
import 'package:sign_language_app/components/custom_text_field.dart';
import 'package:sign_language_app/components/snack_bar.dart';
import 'package:sign_language_app/screens/navigation/main_navigation.dart';
import 'package:sign_language_app/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
Widget build(BuildContext context) {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void check(BuildContext context) async {
    
    if (passwordController.text == "" || emailController.text == "") {
      final snackBar = buildCustomSnackBar(
        text: 'Empty Field/s',
        type: SnackBarType.warning,
        duration: const Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    try {
      // Query Firestore to check if user with given email exists
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: emailController.text)
          .limit(1)
          .get();

      // If no user found with the given email
      if (querySnapshot.docs.isEmpty) {
        final snackBar = buildCustomSnackBar(
          text: 'Invalid Credential/s',
          type: SnackBarType.error,
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return; // Exit the function if user doesn't exist
      }

      // Get the first document in the query result
      final userDoc = querySnapshot.docs.first;

      // Check if the password matches
      if (userDoc['password'] != passwordController.text) {
        final snackBar = buildCustomSnackBar(
          text: 'Invalid Credential/s',
          type: SnackBarType.error,
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return; // Exit the function if password is incorrect
      }

      // Password is correct, save ID and navigate to another screen upon successful login
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user_id', userDoc.id);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavigationScreen()),
      );
      emailController.clear();
      passwordController.clear();

    } catch (e) {
      final snackBar = buildCustomSnackBar(
          text: 'An Error Occured. Please try again later',
          type: SnackBarType.error,
          duration: const Duration(seconds: 2),
        );
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // Handle any errors, e.g., show an error message to the user
    }
}

  return Scaffold(
    body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('static/images/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextField(
                    key: const Key('emailField'),
                    hintText: 'Enter your email',
                    labelText: 'Email',
                    isPassword: false,
                    controller: emailController,
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextField(
                    key: const Key('passwordField'),
                    hintText: 'Enter your password',
                    labelText: 'Password',
                    isPassword: true,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 16.0),
                  CustomButton(
                    text: 'Login',
                    onPressed: () {
                      check(context);
                    },
                  ),
                  const SizedBox(height: 8.0),
                  const SizedBox(height: 0.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      const Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.6,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}



}
