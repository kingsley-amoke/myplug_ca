// lib/features/chat/views/widgets/chat_item.dart
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:myplug_ca/core/constants/images.dart';
import 'package:myplug_ca/features/chat/domain/models/conversation.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

class ChatItem extends StatelessWidget {
  final Conversation conversation;
  final MyplugUser otherUser;
  final VoidCallback? onTap;

  const ChatItem({
    super.key,
    required this.conversation,
    required this.otherUser,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final time = conversation.lastSentAt != null
        ? DateFormat('hh:mm a').format(conversation.lastSentAt!)
        : '';

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: otherUser.image == null
            ? const AssetImage(noUserImage)
            : NetworkImage(otherUser.image!),
      ),
      title: Text(otherUser.fullname),
      subtitle: Text(conversation.lastMessage ?? ''),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          if (conversation.unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Text(
                '${conversation.unreadCount}',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }
}
