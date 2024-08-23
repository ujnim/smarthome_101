import 'package:flutter/material.dart';

class Font extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final bool fontWeight;
  final TextOverflow? overflow;


  const Font({
    super.key,
    required this.text,
    required this.fontSize,
    this.textColor = Colors.black,
    this.fontWeight = false,
    this.overflow,

  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight ? FontWeight.bold : FontWeight.normal,
        color: textColor,
      ),
      softWrap: true,
      overflow: overflow ?? TextOverflow.ellipsis
    );
  }
}
