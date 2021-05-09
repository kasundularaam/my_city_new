import 'package:flutter/material.dart';

class PageBackground extends StatelessWidget {
  final double height;
  final double width;
  const PageBackground({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Image.asset(
        "assets/images/1.png",
        fit: BoxFit.cover,
      ),
    );
  }
}
