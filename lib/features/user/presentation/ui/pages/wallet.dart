// lib/features/wallet/views/wallet_page.dart
import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/user/presentation/ui/widgets/transaction_group.dart';
import 'package:myplug_ca/features/user/presentation/ui/widgets/wallet_card.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final groupedTxns = groupTransactionsByDate(
        context.read<UserProvider>().myplugUser!.transactions);

    return Scaffold(
      appBar: myAppbar(context, title: 'Wallet', implyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            walletCard(context),
            const SizedBox(height: 24),
            Expanded(
              child: groupedTxns.isEmpty
                  ? const Center(child: Text('No transactions found'))
                  : ListView.builder(
                      itemCount: groupedTxns.length,
                      itemBuilder: (context, index) {
                        final date = groupedTxns.keys.elementAt(index);
                        final txns = groupedTxns[date]!;
                        return transactionGroup(context,
                            date: date, txns: txns);
                      },
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
