import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/bottom_nav.dart';
import 'package:myplug_ca/features/product/presentation/view_models/product_provider.dart';
import 'package:myplug_ca/features/promotion/presentation/viewmodels/promotion_provider.dart';
import 'package:myplug_ca/features/subscription/presentation/viewmodels/subscription_provider.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/signin.dart';
import 'package:provider/provider.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  void checkAndCancelPromotions(BuildContext context) async {
    final productProvider = context.read<ProductProvider>();
    List<String> productIds =
        await context.read<PromotionProvider>().checkAndCancelPromotions();
    productProvider.checkAndCancelPromotions(productIds);
  }

  @override
  Widget build(BuildContext context) {
    checkAndCancelPromotions(context);
    if (FirebaseAuth.instance.currentUser != null) {
      context
          .read<SubscriptionProvider>()
          .loadUserSubscription(FirebaseAuth.instance.currentUser!.uid);

      return const BottomNav();
    } else {
      return const LoginPage();
    }
  }
}
