import 'package:flutter/material.dart';
import 'package:myplug_ca/core/constants/demoPromotionPlans.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/product/domain/models/product.dart';
import 'package:myplug_ca/features/promotion/presentation/ui/widgets/promotion_card.dart';

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
        child: ListView.builder(
          itemCount: demoPromotionPlans.length,
          itemBuilder: (context, index) {
            final plan = demoPromotionPlans[index];
            return PromotionCard(
              product: product,
              plan: plan,
            );
          },
        ),
      ),
    );
  }
}
