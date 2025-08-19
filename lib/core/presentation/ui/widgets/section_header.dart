import 'package:flutter/material.dart';

Widget sectionHeader(
    {required String title,
    IconData? icon,
    bool show = true,
    required VoidCallback onAdd}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      show
          ? IconButton(
              onPressed: onAdd,
              icon: Icon(icon ?? Icons.add),
              tooltip: 'Add $title',
            )
          : Container(),
    ],
  );
}
