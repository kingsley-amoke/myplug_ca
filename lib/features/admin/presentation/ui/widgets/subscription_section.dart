import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/modular_search_filter_bar.dart';
import 'package:myplug_ca/features/subscription/domain/models/subscription.dart';
import 'package:myplug_ca/features/subscription/presentation/ui/widgets/user_sub_card.dart';
import 'package:myplug_ca/features/subscription/presentation/viewmodels/subscription_provider.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class SubscriptionSection extends StatefulWidget {
  const SubscriptionSection({
    super.key,
  });

  @override
  State<SubscriptionSection> createState() => _SubscriptionSectionState();
}

class _SubscriptionSectionState extends State<SubscriptionSection> {
  void _onCancel(BuildContext context,
      {required Subscription sub, required MyplugUser user}) async {
    final userProvider = context.read<UserProvider>();
    await context.read<SubscriptionProvider>().cancelUserSubscription(sub);
    userProvider.updateUserSub(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SubscriptionProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              ModularSearchFilterBar(
                showFilterIcon: false,
                onSearch: (search, _) {
                  context.read<SubscriptionProvider>().searchAllSubscriptions(
                        search: search,
                        allUsers: context.read<UserProvider>().allUsers,
                      );
                },
              ),
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: provider.filteredSubscriptions.length,
                  itemBuilder: (context, index) {
                    final sub = provider.filteredSubscriptions[index];
                    final user = context
                        .read<UserProvider>()
                        .allUsers
                        .firstWhere((u) => u.id == sub.userId);
                    return UserSubCard(
                      subscription: sub,
                      username: user.fullname,
                      isAdmin: true,
                      onCancel: () => _onCancel(context, sub: sub, user: user),
                    );
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
