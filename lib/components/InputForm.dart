import 'package:flutter/material.dart';
import 'package:smart_home101/components/Font.dart';
import 'package:smart_home101/components/colors/AppColor.dart';

class InputForm extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final bool isRequired;

  const InputForm({
    super.key,
    required this.controller,
    required this.hintText,
    this.isRequired = false,
    this.validator,
    this.borderColor = AppColor.gray,
    this.focusedBorderColor = AppColor.primary,
    this.errorBorderColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Font(
              text: hintText,
              fontSize: 14,
              fontWeight: true,
            ),
            if(isRequired)
              const SizedBox(width: 5,),
              const Font(text: "*", fontSize: 14, textColor: Colors.red,fontWeight: true,)
          ],
        ),
        const SizedBox(height: 5,),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: focusedBorderColor, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: errorBorderColor, width: 2.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: errorBorderColor, width: 2.0),
            ),
            contentPadding: const EdgeInsets.all(12),
            // filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
