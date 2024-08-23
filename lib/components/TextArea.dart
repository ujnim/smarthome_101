import 'package:flutter/material.dart';
import 'package:smart_home101/components/Font.dart';
import 'package:smart_home101/components/colors/AppColor.dart';

class TextArea extends StatefulWidget {
  final int maxLength;
  final String? title;
  final String? hintText;
  final TextEditingController? controller;

  const TextArea({
    super.key,
    required this.maxLength,
    required this.title,
    this.hintText,
    this.controller,
  });

  @override
  _TextAreaState createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  late TextEditingController _controller;
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_updateLength);
  }

  void _updateLength() {
    setState(() {
      _currentLength = _controller.text.length;
    });

    if (_currentLength > widget.maxLength) {
      _controller.text = _controller.text.substring(0, widget.maxLength);
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.maxLength),
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateLength);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = AppColor.gray;
    const focusedBorderColor = AppColor.primary;
    const errorBorderColor = Colors.red;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.title != null)
                Row(
                  children: [
                    Font(text: widget.title!, fontSize: 14, fontWeight: true),
                    const Font(
                      text: "*",
                      fontSize: 14,
                      fontWeight: true,
                      textColor: Colors.red,
                    ),
                  ],
                ),
              Text(
                '${_currentLength}/${widget.maxLength}',
                style: TextStyle(
                  color: _currentLength > widget.maxLength
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        TextField(
          controller: _controller,
          maxLines: null,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: borderColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: borderColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: focusedBorderColor, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: errorBorderColor, width: 2.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: errorBorderColor, width: 2.0),
            ),
            contentPadding: const EdgeInsets.all(12),
            // filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
