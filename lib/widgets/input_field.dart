// lib/widgets/input_field.dart
import 'package:agriplant/utils/contants.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String? hintText;
  final String labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final VoidCallback? onTap;
  final TextAlign textAlign;
  final bool readOnly;
  final bool floatLabel;
  final int? maxLines;
  final VoidCallback? onSuffixIconPressed; // Thêm callback cho suffix icon
  final void Function(String)? onChanged;
  final TextStyle? textStyle;
  final List<String>? autofillHints;

  const InputField({
    Key? key,
    this.hintText,
    required this.labelText,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor = Colors.grey,
    this.onTap,
    this.textStyle,
    this.floatLabel = false,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.autofillHints,
    this.readOnly = false,
    this.onSuffixIconPressed,
    this.onChanged, // Thêm vào constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lấy màu từ theme để sử dụng cho viền khi focused
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textAlign: textAlign,
        onTap: onTap,
        readOnly: readOnly,
        style: textStyle ?? const TextStyle(fontSize: 18), // Áp dụng textStyle
        maxLines: maxLines,
        autofillHints: autofillHints,
        onChanged: onChanged, // Truyền xuống TextFormField
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelBehavior: floatLabel
              ? FloatingLabelBehavior.always
              : FloatingLabelBehavior.auto,
          labelStyle: const TextStyle(fontSize: 20),
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon != null
              ? GestureDetector(
                  onTap: onSuffixIconPressed,
                  child: suffixIcon,
                )
              : null,
          contentPadding:
               EdgeInsets.symmetric(horizontal:  (prefixIcon != null? 15.0 : 4.0), vertical: 15.0),
          filled: true,
          fillColor: fillColor?.withOpacity(0.1),
          // Viền khi không được focus
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
          // Viền khi được focus
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(color: primaryColor, width: 1.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: tomatoColor, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: tomatoColor, width: 1.0),
          ),
          // Viền mặc định (nếu cần)
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
          // Loại bỏ padding mặc định để căn chỉnh tốt hơn
        ),
      ),
    );
  }
}
