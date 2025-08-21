import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;
  final String Function(T) itemLabelBuilder; // converts item to String

  const CustomDropdown({
    super.key,
    required this.items,
    required this.itemLabelBuilder,
    this.value,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        hintText: hintText,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          fontSize: 15,
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          color: theme.colorScheme.primary.withOpacity(0.8),
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
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(itemLabelBuilder(item)),
              ))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
