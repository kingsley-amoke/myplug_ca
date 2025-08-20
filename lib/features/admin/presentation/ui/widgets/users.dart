import 'package:flutter/material.dart';
import 'package:myplug_ca/features/admin/presentation/ui/widgets/user_card.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class UsersSection extends StatelessWidget {
  const UsersSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: provider.allUsers.length,
            itemBuilder: (context, index) {
              final user = provider.allUsers[index];
              return UserCard(user: user);
            },
          );
        },
      ),
    );
  }
}
