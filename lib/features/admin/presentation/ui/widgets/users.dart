import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/modular_search_filter_bar.dart';
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
          return Column(
            children: [
              ModularSearchFilterBar(
                showFilterIcon: false,
                onSearch: (search, _) {
                  context.read<UserProvider>().searchAllUsers(
                        search: search,
                      );
                },
              ),
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: provider.filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = provider.filteredUsers[index];
                    return UserCard(user: user);
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
