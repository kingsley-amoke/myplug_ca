// lib/core/presentation/ui/widgets/user_card.dart
import 'package:flutter/material.dart';
import 'package:fixnbuy/features/user/domain/models/myplug_user.dart';

class UserCard extends StatelessWidget {
  final MyplugUser user;
  final VoidCallback? onBook;
  final VoidCallback? onViewProfile;

  const UserCard({
    super.key,
    required this.user,
    this.onBook,
    this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey[300],
              backgroundImage:
                  user.image != null ? NetworkImage(user.image!) : null,
              child: user.image == null
                  ? Text(
                      (user.firstName?.substring(0, 1) ?? '?').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullname,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.location?.address ?? "No location",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  if (user.skills.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        user.skills.first.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[700],
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),

            // Action Buttons
            Column(
              children: [
                ElevatedButton(
                  onPressed: onBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle:
                        const TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  child: const Text(
                    "Book",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 6),
                OutlinedButton(
                  onPressed: onViewProfile,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(fontSize: 13),
                  ),
                  child: const Text("Profile"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
