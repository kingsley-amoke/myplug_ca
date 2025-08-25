import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:fixnbuy/core/config/config.dart';
import 'package:fixnbuy/core/domain/models/toast.dart';
import 'package:fixnbuy/features/promotion/domain/models/promotion_plan.dart';
import 'package:fixnbuy/features/promotion/presentation/viewmodels/promotion_provider.dart';
import 'package:fixnbuy/features/subscription/domain/models/subscription_plan.dart';
import 'package:provider/provider.dart';

class PromotionAdminPage extends StatelessWidget {
  const PromotionAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PromotionProvider>(builder: (context, provider, _) {
        return Flexible(
          child: ListView.builder(
              itemCount: provider.plans.length,
              itemBuilder: (context, index) {
                final plan = provider.plans[index];

                return EditablePromotionPlanCard(plan: plan, onSave: (plan) {});
              }),
        );
      }),
    );
  }
}

class EditablePromotionPlanCard extends StatefulWidget {
  final PromotionPlan plan;
  final Function(SubscriptionPlan updatedPlan) onSave;

  const EditablePromotionPlanCard({
    super.key,
    required this.plan,
    required this.onSave,
  });

  @override
  State<EditablePromotionPlanCard> createState() =>
      _EditablePromotionPlanCardState();
}

class _EditablePromotionPlanCardState extends State<EditablePromotionPlanCard> {
  late TextEditingController _priceController;
  // late TextEditingController _featureController;
  // late List<String> _features;

  @override
  void initState() {
    super.initState();
    _priceController =
        TextEditingController(text: widget.plan.price.toStringAsFixed(2));
    // _featureController = TextEditingController();
    // _features = List.from(widget.plan.features);
  }

  // void addFeature() {
  //   final feature = _featureController.text.trim();
  //   if (feature.isNotEmpty) {
  //     setState(() {
  //       _features.add(feature);
  //       _featureController.clear();
  //     });
  //   }
  // }

  // void removeFeature(int index) {
  //   setState(() {
  //     _features.removeAt(index);
  //   });
  // }

  void saveChanges() {
    final price = double.tryParse(_priceController.text.trim());
    if (price == null || price <= 0) {
      showToast(message: "Please enter a valid price", type: ToastType.error);
      return;
    }

    context
        .read<PromotionProvider>()
        .updatePlan(plan: widget.plan, price: price)
        .then((_) {
      showToast(message: 'Success', type: ToastType.success);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.plan.title.toCapitalCase(),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Highlight: ${formatPlanHighlight(widget.plan.highlight)}",
                style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),

            /// Editable Price
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price",
                prefixText: "₦ ",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // /// Features Section
            // Text("Features", style: Theme.of(context).textTheme.titleMedium),
            // SizedBox(height: 8),
            // ..._features.asMap().entries.map((entry) {
            //   return Row(
            //     children: [
            //       Expanded(child: Text(entry.value)),
            //       IconButton(
            //         icon: Icon(Icons.delete, color: Colors.red),
            //         onPressed: () => removeFeature(entry.key),
            //       ),
            //     ],
            //   );
            // }).toList(),
            // SizedBox(height: 8),
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextField(
            //         controller: _featureController,
            //         decoration: InputDecoration(
            //           labelText: "Add feature",
            //           border: OutlineInputBorder(),
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 8),
            //     ElevatedButton(
            //       onPressed: addFeature,
            //       child: Text("Add"),
            //     )
            //   ],
            // ),
            // SizedBox(height: 16),

            /// Save Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: saveChanges,
                icon: const Icon(Icons.save),
                label: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
