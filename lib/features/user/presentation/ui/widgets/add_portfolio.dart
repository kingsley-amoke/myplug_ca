// lib/features/user/views/add_portfolio_page.dart
import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_dialog.dart';

class AddPortfolioPage extends StatefulWidget {
  const AddPortfolioPage({super.key});

  @override
  State<AddPortfolioPage> createState() => _AddPortfolioPageState();
}

class _AddPortfolioPageState extends State<AddPortfolioPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _linkController = TextEditingController();

  final List<String> _imageUrls = [];

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final title = _titleController.text.trim();
      final desc = _descController.text.trim();
      final link = _linkController.text.trim();

      // TODO: Save portfolio logic here

      Navigator.pop(context);
    }
  }

  void _addImageUrl() async {
    final url = await showDialog<String>(
      context: context,
      builder: (_) => ImageUrlDialog(),
    );
    if (url != null && url.isNotEmpty) {
      setState(() => _imageUrls.add(url));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Portfolio')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Project Title',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Project Link (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _addImageUrl,
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Add Image URL'),
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: _imageUrls
                    .map((url) => Chip(
                          label: Text('Image ${_imageUrls.indexOf(url) + 1}'),
                          onDeleted: () =>
                              setState(() => _imageUrls.remove(url)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.upload),
                label: const Text('Submit Portfolio'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
