// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:traveler/app/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    Key? key,
    required this.webS,
    required this.mobileS,
  }) : super(key: key);
  final Widget webS;
  final Widget mobileS;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScr) {
          // web
          return webS;
        } else {
          // mobile
          return mobileS;
        }
      },
    );
  }
}
