import 'dart:io';

import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:fixnbuy/core/config/config.dart';
import 'package:fixnbuy/core/constants/nigerian_states.dart';
import 'package:fixnbuy/core/constants/shops.dart';
import 'package:fixnbuy/core/constants/validators.dart';
import 'package:fixnbuy/core/domain/models/toast.dart';
import 'package:fixnbuy/core/presentation/ui/widgets/custom_dropdown.dart';
import 'package:fixnbuy/core/presentation/ui/widgets/my_appbar.dart';
import 'package:fixnbuy/core/presentation/ui/widgets/my_input.dart';
import 'package:fixnbuy/features/product/domain/models/myplug_shop.dart';
import 'package:fixnbuy/features/product/presentation/view_models/product_provider.dart';
import 'package:fixnbuy/features/user/presentation/view_models/user_provider.dart';
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

  final List<File> _images = [];
  MyplugShop? _selectedShop;
  String? _location;

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

      final navigator = Navigator.of(context);

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

        showToast(message: 'Success', type: ToastType.success);
        navigator.pop();
      } catch (e) {
        setState(() => _isLoading = false);
        showToast(message: 'Something went wrong', type: ToastType.error);
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
              //location
              CustomDropdown<String>(
                items: nigerianStates,
                itemLabelBuilder: (state) => state.toSentenceCase(),
                value: _location,
                labelText: "Product Location",
                hintText: "Select product location",
                prefixIcon: Icons.category_outlined,
                validator: (v) => v == null ? "Select product location" : null,
                onChanged: (val) => setState(
                  () => _location = val ?? _location,
                ),
              ),
              const SizedBox(height: 16),

              // Shop Dropdown
              CustomDropdown<MyplugShop>(
                items: shops,
                itemLabelBuilder: (shop) => shop.name.toSentenceCase(),
                value: _selectedShop,
                labelText: "Product Shop",
                hintText: "Select product shop",
                prefixIcon: Icons.category_outlined,
                validator: (v) => v == null ? "Select product shop" : null,
                onChanged: (val) => setState(
                  () => _selectedShop = val ?? _selectedShop,
                ),
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
