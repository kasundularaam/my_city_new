import 'package:flutter/material.dart';

class CustomLoading {
  static void showLoadingDialog({
    BuildContext context,
    String message,
  }) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(message),
                  )
                ],
              ),
            ),
          );
        });
  }

  static void closeLoading({BuildContext context}) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
