import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

Widget walletCard(BuildContext context) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: StreamBuilder(
        stream: context.watch<UserProvider>().getUserStream(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final user = snapshot.data!;
          return Column(
            children: [
              Text('Total Balance',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text(
                formatPrice(amount: user.balance),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wallet_giftcard, color: Colors.orange),
                  const SizedBox(width: 6),
                  Text('Bonus: ${formatPrice(amount: user.bonus)}'),
                ],
              ),
            ],
          );
        },
      ),
    ),
  );
}
