import 'package:flutter/material.dart';

class MyInputField extends StatelessWidget {
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final bool isPassword;
  final String hintText;
  final double fontSize;

  MyInputField(
      {this.hintText,
      this.onChanged,
      this.onSubmitted,
      this.focusNode,
      this.textInputAction,
      this.isPassword,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    bool _isPassword = isPassword ?? false;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
      child: TextField(
        obscureText: _isPassword,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        focusNode: focusNode,
        style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
            fontWeight: FontWeight.w300),
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.all(12.0),
          border: InputBorder.none,
        ),
        textInputAction: textInputAction,
      ),
    );
  }
}
