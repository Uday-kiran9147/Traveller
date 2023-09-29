import 'package:flutter/material.dart';

customSnackbarMessage(String message, BuildContext context, Color color) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 10),
      elevation: 8,
      margin: const EdgeInsets.all(12),
      content: Text(message)));
}
