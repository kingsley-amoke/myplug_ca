import 'package:flutter/material.dart';
import 'package:myplug_ca/features/admin/presentation/ui/widgets/product_card.dart';
import 'package:myplug_ca/features/product/domain/models/product.dart';
import 'package:myplug_ca/features/product/presentation/ui/pages/add_product.dart';
import 'package:myplug_ca/features/product/presentation/view_models/product_provider.dart';
import 'package:provider/provider.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          return provider.products.isEmpty
              ? const Center(child: Text("No products available"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.products.length,
                  itemBuilder: (context, index) {
                    Product product = provider.products[index];
                    return ProductCard(product: product);
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductPage()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2,
        child: const Icon(
          Icons.add_rounded,
          size: 28,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
