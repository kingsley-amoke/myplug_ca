import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/subscription/presentation/ui/widgets/subscription_card.dart';
import 'package:myplug_ca/features/subscription/presentation/viewmodels/subscription_provider.dart';
import 'package:provider/provider.dart';

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
        child: Consumer<SubscriptionProvider>(
          builder: (context, provider, _) {
            return ListView.builder(
              itemCount: provider.plans.length,
              itemBuilder: (context, index) {
                final plan = provider.plans[index];
                return SubscriptionCard(plan: plan);
              },
            );
          },
        ),
      ),
    );
  }
}
