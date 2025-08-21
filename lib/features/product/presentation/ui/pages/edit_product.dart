import 'dart:io';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/nigerian_states.dart';
import 'package:myplug_ca/core/domain/models/toast.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/custom_dropdown.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_input.dart';
import 'package:myplug_ca/features/product/domain/models/product.dart';
import 'package:myplug_ca/features/product/presentation/view_models/product_provider.dart';
import 'package:provider/provider.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  final List<File> _newImages = [];
  late List<String> _existingImages;
  late String _location;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _priceController =
        TextEditingController(text: widget.product.price.toString());

    _existingImages = List<String>.from(widget.product.images);

    _location = widget.product.location;
  }

  Future<void> _pickImage() async {
    final picked = await pickImage();
    if (picked != null) {
      setState(() {
        _newImages.add(picked);
      });
    }
  }

  void _removeExistingImage(String url) {
    setState(() {
      _existingImages.remove(url);
    });
  }

  void _removeNewImage(File file) {
    setState(() {
      _newImages.remove(file);
    });
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        saving = true;
      });
      final double price = double.tryParse(_priceController.text.trim()) ?? 0.0;

      await context.read<ProductProvider>().editProduct(
            product: widget.product,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            location: _location,
            price: price,
            existingImages: _existingImages,
            newImages: _newImages,
          );
      showToast(context, message: 'Success', type: ToastType.success);
      Navigator.pop(context);
      saving = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(
        context,
        title: "Edit Product",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              MyInput(
                controller: _titleController,
                labelText: "Product Title",
                validator: (value) => value == null || value.isEmpty
                    ? "Enter product title"
                    : null,
              ),
              const SizedBox(height: 16),

              // Description
              MyInput(
                controller: _descriptionController,
                hintText: "Description",
                maxLines: 4,
                validator: (value) => value == null || value.isEmpty
                    ? "Enter product description"
                    : null,
              ),
              const SizedBox(height: 16),

              //location
              CustomDropdown<String>(
                items: nigerianStates,
                itemLabelBuilder: (state) => state.toSentenceCase(),
                value: widget.product.location,
                labelText: "Product Location",
                hintText: "Select product location",
                prefixIcon: Icons.category_outlined,
                validator: (v) => v == null ? "Select product type" : null,
                onChanged: (val) => setState(
                  () => _location = val ?? _location,
                ),
              ),
              const SizedBox(height: 20),
              // Price
              MyInput(
                controller: _priceController,
                labelText: "Price",
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter price";
                  if (double.tryParse(value) == null) {
                    return "Enter a valid number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Images Section
              Text("Images", style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Existing Images
                    ..._existingImages.map((url) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  url,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => _removeExistingImage(url),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(Icons.close,
                                        color: Colors.white, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),

                    // New Images
                    ..._newImages.map((file) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  file,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => _removeNewImage(file),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(Icons.close,
                                        color: Colors.white, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),

                    // Add Button
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add_a_photo, size: 32),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProduct,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: saving
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Save Changes",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
