import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  primaryTextTheme: TextTheme(
    displayMedium: TextStyle(
      fontFamily: 'BBT',
      fontWeight: FontWeight.bold, // Use the custom font family
    ),
    headlineSmall: TextStyle(
      fontFamily: 'MonaSans',
      // fontStyle: FontStyle.italic, // Use the custom font family
      fontWeight: FontWeight.bold, // Use the custom font family
    ),
  ),
  // colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
  colorScheme:
      ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 93, 39, 179)),
);
