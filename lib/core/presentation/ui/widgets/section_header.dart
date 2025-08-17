
  import 'package:flutter/material.dart';

Widget sectionHeader({required String title, IconData? icon, required VoidCallback onAdd}) {
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