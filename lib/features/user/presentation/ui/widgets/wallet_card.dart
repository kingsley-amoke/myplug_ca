import 'package:flutter/material.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

Widget walletCard(BuildContext context) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Consumer<UserProvider>(
        builder: (BuildContext context, provider, Widget? child) {
          return Column(
            children: [
              Text('Total Balance',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text(
                '₦${provider.myplugUser!.balance.toStringAsFixed(2)}',
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
                  Text(
                      'Bonus: ₦${provider.myplugUser!.bonus.toStringAsFixed(2)}'),
                ],
              ),
            ],
          );
        },
      ),
    ),
  );
}
