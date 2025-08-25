import 'package:flutter/material.dart';
import 'package:fixnbuy/features/subscription/domain/models/subscription.dart';

class CancelSubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback onCancel;

  const CancelSubscriptionCard({
    super.key,
    required this.subscription,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // Cancel Button
            ElevatedButton.icon(
              onPressed: subscription.isActive ? onCancel : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.cancel),
              label: const Text("Cancel Subscription"),
            ),

            const SizedBox(height: 10),

            // Warning note
            Text(
              "⚠️ Cancelling will remove your premium access immediately.",
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
