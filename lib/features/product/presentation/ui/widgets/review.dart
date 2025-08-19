import 'package:flutter/material.dart';
import 'package:myplug_ca/core/domain/models/rating.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:star_rating/star_rating.dart';

class ProductRatingDialog extends StatefulWidget {
  const ProductRatingDialog({super.key, required this.submitReview});

  final Function(Rating) submitReview;

  @override
  State<ProductRatingDialog> createState() => _ProductRatingDialogState();
}

double _rating = 1;
final TextEditingController _commentCtrl = TextEditingController();

class _ProductRatingDialogState extends State<ProductRatingDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Write a Review",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Rating
            const Text(
              "Your Rating",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            StatefulBuilder(
              builder: (context, setInnerState) {
                return StarRating(
                  length: 5,
                  rating: _rating,
                  starSize: 32,
                  color: Colors.amber,
                  onRaitingTap: (value) {
                    setInnerState(() => _rating = value);
                  },
                );
              },
            ),
            const SizedBox(height: 20),

            // Comment
            const Text(
              "Your Review",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentCtrl,
              decoration: InputDecoration(
                hintText: "Write something...",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    final userProvider = context.read<UserProvider>();
                    if (_rating > 0 &&
                        _commentCtrl.text.trim().isNotEmpty &&
                        userProvider.isLoggedIn) {
                      final newReview = Rating(
                        username: userProvider.myplugUser!.fullname,
                        rating: _rating,
                        comment: _commentCtrl.text.trim(),
                        date: DateTime.now(),
                      );

                      widget.submitReview(newReview);
                    }

                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
