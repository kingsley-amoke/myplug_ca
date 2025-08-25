import 'package:flutter/material.dart';
import 'package:fixnbuy/core/presentation/ui/widgets/modular_search_filter_bar.dart';
import 'package:fixnbuy/features/user/presentation/ui/widgets/transaction_item.dart';
import 'package:fixnbuy/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class TransactionsSection extends StatefulWidget {
  const TransactionsSection({
    super.key,
  });

  @override
  State<TransactionsSection> createState() => _TransactionsSectionState();
}

class _TransactionsSectionState extends State<TransactionsSection> {
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
                  context.read<UserProvider>().searchAllTransactions(
                        search: search,
                      );
                },
              ),
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: provider.filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final txn = provider.filteredTransactions[index];
                    return transactionItem(
                      context,
                      txn: txn,
                    );
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
