import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.prefixText,
    this.suffixText,
    this.keyboardType,
    this.maxLength,
    this.maxLines,
    this.textInputAction,
    this.validator,
    this.enabled,
    this.useLoginStyle = false,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final String? prefixText;
  final String? suffixText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool? enabled;
  final bool useLoginStyle;

  @override
  Widget build(BuildContext context) {
    Widget? labelWidget;

    if (labelText != null && useLoginStyle) {
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
    } else {
      labelWidget = Text(labelText!);
    }

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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        label: labelWidget,
        hintText: hintText,
        prefixIcon: prefixIcon,
        prefixText: prefixText,
        suffixText: suffixText,
        filled: useLoginStyle,
        fillColor: Colors.blue.shade50,
      ),
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      textInputAction: textInputAction,
      validator: validator,
      enabled: enabled,
    );
  }
}
