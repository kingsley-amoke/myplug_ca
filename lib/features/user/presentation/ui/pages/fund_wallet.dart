import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/validators.dart';
import 'package:myplug_ca/core/domain/models/toast.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_input.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class FundWalletPage extends StatefulWidget {
  const FundWalletPage({super.key});

  @override
  State<FundWalletPage> createState() => _FundWalletPageState();
}

class _FundWalletPageState extends State<FundWalletPage> {
  final TextEditingController _amountController = TextEditingController();
  // String _selectedPaymentMethod = 'Card';
  bool _isSubmitting = false;

  void _fundWallet() async {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid amount")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await context.read<UserProvider>().fundWallet(amount);
      showToast(
        context,
        message: "Wallet funded with ${formatPrice(amount: amount)}",
        type: ToastType.success,
      );
      _amountController.clear();
      Navigator.of(context).pop();
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().myplugUser!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: myAppbar(
        context,
        title: "Fund Wallet",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Balance
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Current Balance",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatPrice(amount: user.balance),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Amount Input
            MyInput(
              controller: _amountController,
              keyboardType: TextInputType.number,
              labelText: "Enter Amount",
              prefixText: "₦ ",
              validator: (v) => textValidator(v),
            ),
            const SizedBox(height: 24),

            const SizedBox(height: 32),

            // Fund Wallet Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _fundWallet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDAA579),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Fund Wallet",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
