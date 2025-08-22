import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/fund_wallet.dart';
import 'package:myplug_ca/features/user/presentation/ui/widgets/transaction_group.dart';
import 'package:myplug_ca/features/user/presentation/ui/widgets/wallet_card.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({
    super.key,
  });

  void _fundWallet(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const FundWalletPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: 'Wallet', implyLeading: false),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (!provider.isLoggedIn) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final groupedTxns =
              groupTransactionsByDate(provider.myplugUser!.transactions);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                walletCard(context),
                const SizedBox(height: 16),

                // Fund Wallet Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _fundWallet(context),
                    icon: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Fund Wallet",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDAA579),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

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
              ],
            ),
          );
        },
      ),
    );
  }
}
