import 'package:flutter/material.dart';
import 'package:myplug_ca/features/user/domain/models/transaction.dart';
import 'package:myplug_ca/features/user/presentation/ui/widgets/transaction_item.dart';

Widget transactionGroup(BuildContext context, {required String date, required List<Transaction> txns}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 16),
      Text(
        date,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
      ),
      const SizedBox(height: 8),
      ...txns.map((txn) => transactionItem(context, txn:txn)),
    ],
  );
}
