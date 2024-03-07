import 'package:flutter/material.dart';

final theme = ThemeData(
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white),
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.blue,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 24,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
  ),
);
