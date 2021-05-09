import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  const RoundButton({
    Key key,
    @required this.text,
    @required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.purple,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 18.0),
          ),
        ),
      ),
      onTap: () {
        onPressed();
      },
    );
  }
}
