import 'package:flutter/material.dart';

class TextContainer extends StatelessWidget {
  TextContainer({
    Key? key,
    required this.text,
    this.fontSize,
    this.selectableText=false,
  }) : super(key: key);
  final String text;
  final double? fontSize;
  final bool? selectableText;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 10),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: selectableText!
          ? SelectableText(text,
              cursorHeight: 30, style: Theme.of(context).textTheme.bodyLarge)
          : Text(
              text,
              style: TextStyle(fontSize: fontSize ?? 12),
            ),
    );
  }
}
