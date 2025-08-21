import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/features/admin/presentation/ui/widgets/stat_card.dart';

Widget overviewSection({
  required int noOfUsers,
  required int noOfJobs,
  required int noOfProducts,
  required int sumOfTransactions,
}) {
  return ListView(
    padding: const EdgeInsets.all(16),
    children: [
      StatCard(
        title: "Users",
        value: formatLargeNumber(noOfUsers),
        icon: Icons.people,
        color: Colors.blue,
      ),
      const SizedBox(height: 12),
      StatCard(
        title: "Jobs",
        value: formatLargeNumber(noOfJobs),
        icon: Icons.work,
        color: Colors.green,
      ),
      const SizedBox(height: 12),
      StatCard(
        title: "Products",
        value: formatLargeNumber(noOfProducts),
        icon: Icons.shopping_bag,
        color: Colors.orange,
      ),
      const SizedBox(height: 12),
      StatCard(
        title: "Transactions",
        value: 'N${formatLargeNumber(sumOfTransactions)}',
        icon: Icons.attach_money,
        color: Colors.purple,
      ),
    ],
  );
}
