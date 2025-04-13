import 'package:flutter/material.dart';
import 'package:myapp/pages/homepage.dart';

// Define your colors
Color bgColor = const Color.fromARGB(255, 235, 221, 255);
Color wht = Colors.white;
Color fgColor = const Color.fromARGB(255, 162, 103, 245);
Color text = const Color.fromARGB(255, 162, 103, 245);
Color ltfg = const Color.fromARGB(255,197, 156, 255);
Color blk = Colors.black;
bool theme = false;

// Function to set the theme
void setTheme(bool dark) {
  if (dark) {
    changeTheme(true);
    bgColor = const Color.fromARGB(255, 19, 2, 43); // Darker background
    text = const Color.fromARGB(
        255, 240, 240, 240); // Light text for dark background
    blk = Colors.white;
  } else {
    changeTheme(false);
    bgColor = const Color.fromARGB(255, 235, 221, 255); // Light background
    text = const Color.fromARGB(255, 162, 103, 245); // Original text color
    blk = Colors.black;
  }
}
