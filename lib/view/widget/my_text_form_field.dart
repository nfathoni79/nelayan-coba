import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    this.labelText,
    this.prefixText,
    this.suffixText,
    this.keyboardType,
    this.maxLength,
    this.maxLines,
    this.textInputAction,
    this.useLoginStyle = true,
  });

  final String? labelText;
  final String? prefixText;
  final String? suffixText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final bool useLoginStyle;

  @override
  Widget build(BuildContext context) {
    Widget? labelWidget;
    Widget? prefixWidget;

    if (labelText != null) {
      labelWidget = Container(
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
        decoration: useLoginStyle
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blue.shade50,
              )
            : null,
        child: Text(labelText!),
      );
    }

    if (prefixText != null) prefixWidget = Text(prefixText!);

    return TextFormField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: useLoginStyle
              ? BorderSide.none
              : BorderSide(
                  color: Colors.grey.shade600,
                ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(16),
        label: labelWidget,
        prefix: prefixWidget,
        suffixText: suffixText,
        filled: useLoginStyle,
        fillColor: Colors.blue.shade50,
      ),
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      textInputAction: textInputAction,
    );
  }
}
