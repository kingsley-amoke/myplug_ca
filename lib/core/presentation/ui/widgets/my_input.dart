import 'package:flutter/material.dart';

class MyInput extends StatelessWidget {
  const MyInput({
    super.key,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.maxLines = 1,
    this.onEditingComplete,
    this.onChanged,
    this.validator,
    this.prefixText,
  });

  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final bool readOnly;
  final int? maxLines;
  final void Function()? onEditingComplete;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        readOnly: readOnly,
        maxLines: maxLines,
        onEditingComplete: onEditingComplete,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 16,
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor:
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          prefixText: prefixText,
          hintText: hintText,
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: 15,
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            color: theme.colorScheme.primary.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.dividerColor,
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 1.8,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
              width: 1.8,
            ),
          ),
        ),
      ),
    );
  }
}
