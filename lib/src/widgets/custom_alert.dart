import 'package:flutter/material.dart';

class CustomAlert {
  static Future<void> alertDialogBuilder({
    BuildContext context,
    String title,
    String message,
    String action,
  }) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                child: Text(action),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
