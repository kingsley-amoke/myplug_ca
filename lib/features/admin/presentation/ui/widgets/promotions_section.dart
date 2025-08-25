import 'package:flutter/material.dart';
// import 'package:fixnbuy/core/presentation/ui/widgets/modular_search_filter_bar.dart';
import 'package:fixnbuy/features/admin/presentation/ui/widgets/product_card.dart';
import 'package:fixnbuy/features/product/domain/models/product.dart';
// import 'package:fixnbuy/features/product/presentation/ui/pages/add_product.dart';
import 'package:fixnbuy/features/product/presentation/view_models/product_provider.dart';
import 'package:provider/provider.dart';

class PromotionsSection extends StatelessWidget {
  const PromotionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          return provider.products.isEmpty
              ? const Center(child: Text("No products available"))
              : Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: provider.promotedProducts.length,
                        itemBuilder: (context, index) {
                          Product product = provider.promotedProducts[index];
                          return ProductCard(product: product);
                        },
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
