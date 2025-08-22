import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/user/domain/models/transaction.dart';

class TransactionDetailsPage extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailsPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == TransactionType.credit;
    final dateFormatted = DateFormat.yMMMMd().add_jm().format(transaction.date);

    return Scaffold(
      appBar: myAppbar(
        context,
        title: 'Transaction Details',
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIconSection(isCredit),
            const SizedBox(height: 24),
            _buildDetailRow('Amount', formatPrice(amount: transaction.amount),
                isPrimary: true),
            _buildDetailRow('Type', isCredit ? 'Credit' : 'Debit'),
            _buildDetailRow('Description', transaction.description),
            _buildDetailRow('Date', dateFormatted),
            _buildDetailRow('Transaction ID', transaction.id),
          ],
        ),
      ),
    );
  }

  Widget _buildIconSection(bool isCredit) {
    return Center(
      child: Column(
        children: [
          Icon(
            isCredit
                ? Icons.arrow_downward_rounded
                : Icons.arrow_upward_rounded,
            size: 48,
            color: isCredit ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 8),
          Text(
            isCredit ? 'Money In' : 'Money Out',
            style: TextStyle(
              fontSize: 16,
              color: isCredit ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isPrimary = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              )),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                fontSize: isPrimary ? 18 : 16,
                fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
