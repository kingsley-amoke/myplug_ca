import 'package:flutter/material.dart';
import 'package:fixnbuy/features/chat/presentation/viewmodels/chat_provider.dart';
import 'package:fixnbuy/features/user/domain/models/myplug_user.dart';
import 'package:fixnbuy/features/user/presentation/ui/pages/profile.dart';
import 'package:fixnbuy/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});

  final MyplugUser user;

  void _viewProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfilePage(user: user),
      ),
    );
  }

  void _suspendUser(BuildContext context) {
    context.read<UserProvider>().suspendUser(user);
  }

  void _makeUserAdmin(BuildContext context) {
    context.read<UserProvider>().makeUserAdmin(user);
  }

  void _deleteUser(BuildContext context) {
    // context.read<UserProvider>().deleteUser();
  }

  void _chatUser(BuildContext context) {
    final userProvider = context.read<UserProvider>();

    if (userProvider.isLoggedIn) {
      context
          .read<ChatProvider>()
          .createOrGetConversation(userProvider.myplugUser!.id!, user.id!);
    }
  }

  void _restoreUser(BuildContext context) {
    context.read<UserProvider>().restoreUser(user);
  }

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
                            ? Colors.blue.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          color: user.isAdmin ? Colors.blue : Colors.grey,
                        ),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 6),
                      Chip(
                        label: Text(user.isSuspended ? "Suspe..." : "Active"),
                        backgroundColor: user.isSuspended
                            ? Colors.red.withValues(alpha: 0.1)
                            : Colors.green.withValues(alpha: 0.1),
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
                    case "profile":
                      _viewProfile(context);
                      break;
                    case "suspend":
                      _suspendUser(context);
                      break;
                    case "restore":
                      _restoreUser(context);
                      break;
                    case "delete":
                      _deleteUser(context);
                      break;
                    case "make_admin":
                      _makeUserAdmin(context);
                      break;
                    case "chat":
                      _chatUser(context);
                      break;
                  }
                },
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "profile",
                        child: Text("Profile"),
                      ),

                      // Show suspend/restore only if not admin
                      if (!user.isAdmin)
                        !user.isSuspended
                            ? const PopupMenuItem(
                                value: "suspend",
                                child: Text("Suspend"),
                              )
                            : const PopupMenuItem(
                                value: "restore",
                                child: Text("Restore"),
                              ),

                      // Show "Make Admin" only if not already admin
                      if (!user.isAdmin)
                        const PopupMenuItem(
                          value: "make_admin",
                          child: Text("Make Admin"),
                        ),

                      const PopupMenuItem(
                        value: "chat",
                        child: Text("Chat User"),
                      ),

                      // Show delete only if not admin
                      if (!user.isAdmin)
                        const PopupMenuItem(
                          value: "delete",
                          child: Text("Delete"),
                        ),
                    ]),
          ],
        ),
      ),
    );
  }
}
