import 'package:flutter/material.dart';

class Bottomsheet {
  final Widget body;
  final VoidCallback onPressed;
  final Color bgColor;
  final Color textColor;

  Bottomsheet({
    required this.body,
    required this.onPressed,
    this.textColor = Colors.white,
    this.bgColor = Colors.white,
  });

  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30), // ปรับค่าตามที่ต้องการ
              ),
            ),
            child: Center(
              child: body,
            ),
          ),
        );
      },
    );
  }
}
