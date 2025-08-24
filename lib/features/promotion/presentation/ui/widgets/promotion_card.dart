import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/domain/models/toast.dart';
import 'package:myplug_ca/core/presentation/viewmodels/myplug_provider.dart';
import 'package:myplug_ca/features/product/domain/models/product.dart';
import 'package:myplug_ca/features/product/presentation/view_models/product_provider.dart';
import 'package:myplug_ca/features/promotion/domain/models/promotion.dart';
import 'package:myplug_ca/features/promotion/domain/models/promotion_plan.dart';
import 'package:myplug_ca/features/subscription/domain/models/highlight.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class PromotionCard extends StatelessWidget {
  final PromotionPlan plan;
  final Product product;

  const PromotionCard({
    super.key,
    required this.plan,
    required this.product,
  });

  String get highlightText {
    switch (plan.highlight) {
      case Highlight.bestValue:
        return "Best Value";
      case Highlight.recommended:
        return "Recommended";
      case Highlight.mostAffordable:
        return "Most Affordable";
      case Highlight.lite:
        return "Lite";
      default:
        return "";
    }
  }

  Color get highlightColor {
    switch (plan.highlight) {
      case Highlight.bestValue:
        return Colors.amber;
      case Highlight.recommended:
        return Colors.blueAccent;
      case Highlight.mostAffordable:
        return Colors.green;
      case Highlight.lite:
        return Colors.purpleAccent;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: plan.highlight != Highlight.none
              ? highlightColor
              : Colors.grey.shade300,
          width: plan.highlight != Highlight.none ? 2 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (plan.highlight != Highlight.none)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  color: highlightColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  highlightText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              plan.title.toCapitalCase(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "${formatPrice(amount: plan.price)} / ${formatPlanDuration(plan.duration)}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: plan.features
                  .map((feature) => Row(
                        children: [
                          const Icon(Icons.check_circle,
                              size: 16, color: Colors.green),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              feature,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: highlightColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  final userProvider = context.read<UserProvider>();

                  final productProvider = context.read<ProductProvider>();
                  final navigator = Navigator.of(context);

                  if (userProvider.isLoggedIn) {
                    if (userProvider.myplugUser!.balance < plan.price) {
                      showToast(
                          message: 'Insufficient balance',
                          type: ToastType.error);
                      return;
                    }

                    final promotion = Promotion(
                      id: '',
                      productId: product.id!,
                      plan: plan,
                      startDate: DateTime.now(),
                      endDate: DateTime.now().add(plan.duration),
                    );
                    context
                        .read<MyplugProvider>()
                        .promoteProduct(
                          user: userProvider.myplugUser!,
                          product: product,
                          promotion: promotion,
                        )
                        .then((res) {
                      if (res) {
                        showToast(message: 'Success', type: ToastType.success);

                        productProvider.promoteProduct(product);

                        navigator.pop();
                      } else {
                        showToast(
                            message: 'Something went wrong',
                            type: ToastType.error);
                      }
                    });
                  }
                },
                child: const Text(
                  "Promote",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
