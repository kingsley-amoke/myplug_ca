import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/features/user/domain/models/transaction.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/transaction_details_page.dart';

Widget transactionItem(BuildContext context, {required Transaction txn}) {
  final isCredit = txn.type == TransactionType.credit;

  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => TransactionDetailsPage(
                transaction: txn,
              )));
    },
    child: Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          isCredit ? Icons.arrow_downward : Icons.arrow_upward,
          color: isCredit ? Colors.green : Colors.red,
        ),
        title: Text(
          '${txn.type.name[0].toUpperCase()}${txn.type.name.substring(1)}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(txn.description),
        trailing: Text(
          '${isCredit ? '+ ' : '- '}${formatPrice(amount: txn.amount)}}',
          style: TextStyle(
            color: isCredit ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
