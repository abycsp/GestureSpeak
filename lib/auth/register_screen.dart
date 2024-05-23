import 'package:sign_language_app/auth/login_screen.dart';
import 'package:sign_language_app/components/custom_button.dart';
import 'package:sign_language_app/components/custom_text_field.dart';
import 'package:sign_language_app/components/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController fullnameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController passwordConfirmController = TextEditingController();

    void check(BuildContext context) async {
    if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty && 
        fullnameController.text.isNotEmpty && passwordConfirmController.text.isNotEmpty) {

          if (passwordController.text == passwordConfirmController.text){

            final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: emailController.text)
            .get();

            if (querySnapshot.docs.isNotEmpty) {
              final snackBar = buildCustomSnackBar(
                text: 'There is an existing account with that email address',
                type: SnackBarType.error,
                duration: const Duration(seconds: 1),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              
            } else {
              // Document with the same email does not exist, add a new document
              await FirebaseFirestore.instance.collection('users').add({
                'name': fullnameController.text,
                'email': emailController.text,
                'password': passwordController.text
                // Don't store passwords in plaintext in your database for security reasons
                // You can use Firebase Authentication for managing user authentication
                // Instead of storing passwords directly in Firestore
            });
            final snackBar = buildCustomSnackBar(
              text: 'Successfully Registered',
              type: SnackBarType.success,
              duration: const Duration(seconds: 1),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
            }
          } else {
            final snackBar = buildCustomSnackBar(
              text: 'Password doesn\'t match',
              type: SnackBarType.warning,
              duration: const Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } else {
      final snackBar = buildCustomSnackBar(
        text: 'Empty Field/s',
        type: SnackBarType.warning,
        duration: const Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('static/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    CustomTextField(
                      key: const Key('fullnameField'),
                      hintText: 'Enter your full name',
                      labelText: 'Full Name',
                      isPassword: false,
                      controller: fullnameController,
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
                    CustomTextField(
                      key: const Key('confirmPasswordField'),
                      hintText: 'Confirm password',
                      labelText: 'Confirm Password',
                      isPassword: true,
                      controller: passwordConfirmController,
                    ),
                    const SizedBox(height: 16.0),
                    CustomButton(
                      text: 'Sign Up',
                      onPressed: () {
                        check(context);
                      },
                    ),

                    const SizedBox(height: 8.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.6,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                          },
                          child: const Text(
                            'Log in',
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
        ),
      ),
    );
  }
}
