import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/features/product/domain/models/product.dart';
import 'package:myplug_ca/features/product/presentation/ui/pages/edit_product.dart';
import 'package:myplug_ca/features/product/presentation/ui/pages/product_details.dart';
import 'package:myplug_ca/features/product/presentation/view_models/product_provider.dart';
import 'package:myplug_ca/features/promotion/presentation/ui/pages/promotion_page.dart';
import 'package:myplug_ca/features/promotion/presentation/viewmodels/promotion_provider.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  void _viewProduct(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetails(product: product),
      ),
    );
  }

  void _editProduct(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditProductPage(product: product),
      ),
    );
  }

  void _cancelProductPromotion(BuildContext context) async {
    final user = context.read<UserProvider>();
    final promotion = context.read<PromotionProvider>();

    if (user.isLoggedIn) {
      await context.read<ProductProvider>().cancelPromotion(product);
      promotion.deletePromotion(product.id!);
    }
  }

  void _promoteProduct(BuildContext context) {
    final user = context.read<UserProvider>();

    if (user.isLoggedIn) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PromotionPage(product: product)));
    }
  }

  void _deleteProduct(BuildContext context) {
    final user = context.read<UserProvider>();

    if (user.isLoggedIn) {
      context
          .read<ProductProvider>()
          .deleteProduct(user: user.myplugUser!, product: product);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPromoted = product.isPromoted;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Product Image with optional promotion badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.images.isEmpty
                        ? 'https://www.bigfootdigital.co.uk/wp-content/uploads/2020/07/image-optimisation-scaled.jpg'
                        : product.images.first,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isPromoted)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'PROMOTED',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    product.title.toCapitalCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),

                  // Shop Name + Seller
                  Text(
                    "${product.shop.name} • ${product.seller.fullname}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 6),

                  // Price
                  Text(
                    formatPrice(amount: product.price),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  // Location
                  Text(
                    product.location.toSentenceCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                ],
              ),
            ),

            // Popup Menu
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case "view":
                    _viewProduct(context);
                    break;
                  case "edit":
                    _editProduct(context);
                    break;
                  case "promote":
                    _promoteProduct(context);
                    break;
                  case "cancel":
                    _cancelProductPromotion(context);
                    break;
                  case "delete":
                    _deleteProduct(context);
                    break;
                }
              },
              itemBuilder: (context) {
                final items = <PopupMenuEntry<String>>[
                  const PopupMenuItem(
                    value: "view",
                    child: Text("View"),
                  ),
                  const PopupMenuItem(
                    value: "edit",
                    child: Text("Edit"),
                  ),
                  // Add Promote only if not promoted
                  !isPromoted
                      ? const PopupMenuItem(
                          value: "promote",
                          child: Text("Promote"),
                        )
                      : const PopupMenuItem(
                          value: "cancel",
                          child: Text("Cancel Promotion"),
                        ),

                  const PopupMenuItem(
                    value: "delete",
                    child: Text("Delete"),
                  ),
                ];

                return items;
              },
            ),
          ],
        ),
      ),
    );
  }
}
