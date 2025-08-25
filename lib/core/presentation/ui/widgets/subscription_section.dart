import 'package:flutter/material.dart';

import 'package:fixnbuy/features/subscription/presentation/ui/widgets/sub_card.dart';
import 'package:fixnbuy/features/subscription/presentation/ui/widgets/user_sub_card.dart';
import 'package:fixnbuy/features/subscription/presentation/viewmodels/subscription_provider.dart';
import 'package:provider/provider.dart';

class SubscriptionSection extends StatelessWidget {
  const SubscriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(builder:
        (BuildContext context, SubscriptionProvider provider, Widget? child) {
      if (provider.subscription == null) {
        return const SubCard();
      } else {
        return UserSubCard(
            isAdmin: false, subscription: provider.subscription!);
      }
    });
  }
}
