import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/product/domain/models/product.dart';
import 'package:myplug_ca/features/promotion/presentation/ui/widgets/promotion_card.dart';
import 'package:myplug_ca/features/promotion/presentation/viewmodels/promotion_provider.dart';
import 'package:provider/provider.dart';

class PromotionPage extends StatelessWidget {
  const PromotionPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(
        context,
        title: "Choose Your Plan",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<PromotionProvider>(
          builder: (context, provider, _) {
            return ListView.builder(
              itemCount: provider.plans.length,
              itemBuilder: (context, index) {
                final plan = provider.plans[index];
                return PromotionCard(
                  product: product,
                  plan: plan,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
