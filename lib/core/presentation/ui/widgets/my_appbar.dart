import 'package:flutter/material.dart';

PreferredSizeWidget myAppbar(
  BuildContext context, {
  required String title,
  bool implyLeading = true,
}) {
  return AppBar(
    automaticallyImplyLeading: implyLeading,
    title: Text(title, style: const TextStyle(color: Colors.black)),
    centerTitle: true,
    leading: implyLeading
        ? IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.chevron_left, color: Colors.black),
          )
        : null,
  );
}
