// lib/features/user/views/widgets/image_url_dialog.dart
import 'package:flutter/material.dart';

class ImageUrlDialog extends StatelessWidget {
  ImageUrlDialog({super.key});

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Image URL'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: 'Enter image URL'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
