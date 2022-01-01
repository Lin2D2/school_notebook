import 'package:flutter/material.dart';

class SnackBarService {
  static void createSimpleSnackBar({
    required BuildContext context,
    required String content,
    Color color=Colors.white
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        backgroundColor: color,
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(seconds: 30),
      ),
    );
  }

  static void createCustomSnackBar(BuildContext context, SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
