//theme.dart
import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Color(0xFFF59B15),
    primaryContainer: Colors.black,
    secondary: Colors.grey,
    secondaryContainer: Color(0xffe7e6e6),
    tertiary: Colors.black12,
  ),
);
ThemeData darkmode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: Color(0xFF303030),
      primary: Color(0xFFF59B15),
      primaryContainer: Colors.white,
      secondary: Color(0xff302f2f),
      secondaryContainer: Color(0xef464545),
      tertiary: Colors.white,
    ));
