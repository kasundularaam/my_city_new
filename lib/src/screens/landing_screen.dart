import 'package:flutter/material.dart';
import 'package:my_city/src/pages/login.dart';
import 'package:my_city/src/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  navigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool access = prefs.getBool("access");
    if (access != null) {
      if (access) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MainScreen(),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LogScreen(),
          ),
          (route) => false,
        );
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LogScreen(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    navigate();
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "MY CITY",
            style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.purpleAccent),
          ),
        ),
      ),
    );
  }
}
