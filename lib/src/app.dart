import 'package:flutter/material.dart';
import 'package:my_city/src/screens/landing_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My CIty",
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: LandingScreen(),
    );
  }
}
