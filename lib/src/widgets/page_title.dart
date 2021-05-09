import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  const PageTitle({
    Key key,
    @required this.title,
    @required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
