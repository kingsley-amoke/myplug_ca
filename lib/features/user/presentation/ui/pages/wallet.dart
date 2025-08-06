// lib/features/wallet/views/wallet_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myplug_ca/core/presentation/ui/pages/home.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/domain/models/transaction.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final groupedTxns = _groupTransactionsByDate(
        context.read<UserProvider>().myplugUser!.transactions);

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildWalletCard(context),
            const SizedBox(height: 24),
            Expanded(
              child: groupedTxns.isEmpty
                  ? const Center(child: Text('No transactions found'))
                  : ListView.builder(
                      itemCount: groupedTxns.length,
                      itemBuilder: (context, index) {
                        final date = groupedTxns.keys.elementAt(index);
                        final txns = groupedTxns[date]!;
                        return _buildTransactionGroup(date, txns);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard(BuildContext context) {
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

  Widget _buildTransactionGroup(String date, List<Transaction> txns) {
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
        ...txns.map((txn) => _buildTransactionItem(txn)).toList(),
      ],
    );
  }

  Widget _buildTransactionItem(Transaction txn) {
    final isCredit = txn.type == TransactionType.credit;

    return Card(
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
          (isCredit ? '+ ' : '- ') + '₦${txn.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: isCredit ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Map<String, List<Transaction>> _groupTransactionsByDate(
      List<Transaction> txns) {
    final Map<String, List<Transaction>> grouped = {};
    for (var txn in txns) {
      final dateStr = DateFormat.yMMMd().format(txn.date);
      grouped.putIfAbsent(dateStr, () => []).add(txn);
    }
    return grouped;
  }
}
