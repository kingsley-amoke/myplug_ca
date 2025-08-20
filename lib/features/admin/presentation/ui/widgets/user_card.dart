import 'package:flutter/material.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});

  final MyplugUser user;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage:
                  user.image != null ? NetworkImage(user.image!) : null,
              child: user.image == null
                  ? Text(
                      user.firstName![0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullname,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Chip(
                        label: Text(user.isAdmin ? "Admin" : "User"),
                        backgroundColor: user.isAdmin
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          color: user.isAdmin ? Colors.blue : Colors.grey,
                        ),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 6),
                      Chip(
                        label: Text(user.isSuspended ? "Suspended" : "Active"),
                        backgroundColor: user.isSuspended
                            ? Colors.red.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          color: user.isSuspended ? Colors.red : Colors.green,
                        ),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case "suspend":
                    // TODO: suspend logic
                    break;
                  case "delete":
                    // TODO: delete logic
                    break;
                  case "make_admin":
                    // TODO: make admin logic
                    break;
                  case "chat":
                    // TODO: chat user logic
                    break;
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: "suspend", child: Text("Suspend User")),
                PopupMenuItem(value: "delete", child: Text("Delete User")),
                PopupMenuItem(value: "make_admin", child: Text("Make Admin")),
                PopupMenuItem(value: "chat", child: Text("Chat User")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
