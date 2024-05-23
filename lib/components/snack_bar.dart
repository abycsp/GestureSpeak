import 'package:flutter/material.dart';

enum SnackBarType { info, success, warning, error }

SnackBar buildCustomSnackBar({
  required String text,
  SnackBarType type = SnackBarType.info,
  Duration duration = const Duration(seconds: 2),
}) {
  Color backgroundColor;
  switch (type) {
    case SnackBarType.info:
      backgroundColor = Colors.blue;
      break;
    case SnackBarType.success:
      backgroundColor = Colors.green;
      break;
    case SnackBarType.warning:
      backgroundColor = Colors.orange;
      break;
    case SnackBarType.error:
      backgroundColor = Colors.red;
      break;
  }

  return SnackBar(
    content: Text(
      text,
      
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        fontSize: 12.0, // Adjust the font size as needed
      ),
    ),
    backgroundColor: backgroundColor,
    duration: duration,
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
    behavior: SnackBarBehavior.floating, // Makes the Snackbar height smaller
  );
}
