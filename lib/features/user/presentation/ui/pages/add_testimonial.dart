// lib/features/user/views/add_testimonial_page.dart
import 'package:flutter/material.dart';

class AddTestimonialPage extends StatefulWidget {
  const AddTestimonialPage({super.key});

  @override
  State<AddTestimonialPage> createState() => _AddTestimonialPageState();
}

class _AddTestimonialPageState extends State<AddTestimonialPage> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  double _rating = 5.0;

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final content = _contentController.text.trim();
      final rating = _rating;

      // TODO: Save testimonial logic here

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Testimonial')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Testimonial',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Please enter content' : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Rating:'),
                  Expanded(
                    child: Slider(
                      value: _rating,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _rating.toString(),
                      onChanged: (val) {
                        setState(() {
                          _rating = val;
                        });
                      },
                    ),
                  ),
                  Text('${_rating.toStringAsFixed(1)} ★'),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.send),
                label: const Text('Submit Testimonial'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
