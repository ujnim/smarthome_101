import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MultiTextSpan extends StatelessWidget {
  final List<Map<String, dynamic>> texts;
  final TextAlign? align;

  const MultiTextSpan({
    super.key,
    required this.texts,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: texts.map((textItem) {
          return TextSpan(
            text: textItem['text'],
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: textItem['color'] ?? Colors.black,
                fontSize: textItem['fontSize'] ?? 14.0,
                fontWeight: textItem['fontWeight'] ?? FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}
