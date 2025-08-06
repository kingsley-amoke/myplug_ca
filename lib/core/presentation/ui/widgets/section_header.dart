
  import 'package:flutter/material.dart';

Widget sectionHeader(String title, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          tooltip: 'Add $title',
        ),
      ],
    );
  }