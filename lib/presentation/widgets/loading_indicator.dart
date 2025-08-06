import 'package:flutter/material.dart';

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      strokeWidth: 2,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }
}