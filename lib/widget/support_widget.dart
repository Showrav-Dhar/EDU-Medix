import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldTextFieldStyle() {
    return TextStyle(
        color: Colors.black, fontSize: 25.00, fontWeight: FontWeight.bold);
  }

  static TextStyle lightTextFieldStyle() {
    return TextStyle(
        color: Color.fromARGB(103, 0, 0, 0),
        fontSize: 20,
        fontWeight: FontWeight.w500);
  }

  static TextStyle semiboldTextFieldStyle() {
    return TextStyle(
        color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold);
  }
}
