import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Utils {
  static void showSnackbar(String message, BuildContext context) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


}