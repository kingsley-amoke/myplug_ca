import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/shops.dart';
import 'package:myplug_ca/core/constants/validators.dart';
import 'package:myplug_ca/core/domain/models/toast.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_input.dart';
import 'package:myplug_ca/features/product/domain/models/myplug_shop.dart';
import 'package:myplug_ca/features/product/presentation/view_models/product_provider.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();

  final List<File> _images = []; // TODO: image picker integration
  MyplugShop? _selectedShop; // TODO: connect to MyplugShop list

  bool _isLoading = false;

  void _pickImage() async {
    final picked = await pickImage();
    if (picked != null) {
      setState(() {
        _images.add(picked);
      });
    }
  }

  void _submit() async {
    final userProvider = context.read<UserProvider>();

    if (_formKey.currentState!.validate() &&
        userProvider.isLoggedIn &&
        _selectedShop != null) {
      setState(() => _isLoading = true);

      final double price = double.tryParse(_priceController.text.trim()) ?? 0.0;

      try {
        await context.read<ProductProvider>().addProduct(
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              price: price,
              location: _locationController.text.trim(),
              shop: _selectedShop!,
              seller: userProvider.myplugUser!,
              images: _images,
            );

        showToast(context, message: 'Success', type: ToastType.success);
        Navigator.pop(context);
      } catch (e) {
        print(e.toString());
        setState(() => _isLoading = false);
        showToast(context,
            message: 'Something went wrong', type: ToastType.error);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(
        context,
        title: "Add Product",
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
                validator: (v) => textValidator(v),
              ),

              const SizedBox(height: 16),
              MyInput(
                controller: _descriptionController,
                hintText: "Description",
                maxLines: 4,
                validator: (v) => textValidator(v),
              ),

              const SizedBox(height: 16),

              // Price
              MyInput(
                controller: _priceController,
                labelText: "Price",
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter price" : null,
              ),
              const SizedBox(height: 16),

              // Location
              MyInput(
                controller: _locationController,
                labelText: "Location",
                prefixIcon: const Icon(Icons.location_city),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter location" : null,
              ),
              const SizedBox(height: 16),

              // Shop Dropdown
              DropdownButtonFormField<MyplugShop>(
                decoration: const InputDecoration(
                  labelText: "Shop",
                  border: OutlineInputBorder(),
                ),
                value: _selectedShop,
                items: shops.map((MyplugShop shop) {
                  return DropdownMenuItem(
                    value: shop,
                    child: Text(shop.name),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedShop = val),
                validator: (val) => val == null ? "Select a shop" : null,
              ),
              const SizedBox(height: 16),

              // Images Upload Section
              Text("Images", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SizedBox(
                height: 90,
                child: Row(
                  children: [
                    // Always visible add button
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 90,
                        height: 90,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add_a_photo, size: 32),
                      ),
                    ),

                    // Scrollable list of images
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _images.map((img) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                img,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          "Add Product",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
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
