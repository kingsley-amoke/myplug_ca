import 'package:flutter/material.dart';
import 'package:myplug_ca/core/constants/demoSubPlans.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/subscription/presentation/ui/widgets/subscription_card.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

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
          itemCount: demoSubPlans.length,
          itemBuilder: (context, index) {
            final plan = demoSubPlans[index];
            return SubscriptionCard(plan: plan);
          },
        ),
      ),
    );
  }
}
