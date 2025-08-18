// // lib/features/chat/views/widgets/chat_item.dart
// import 'package:flutter/material.dart';

// import 'package:intl/intl.dart';
// import 'package:myplug_ca/core/constants/images.dart';
// import 'package:myplug_ca/features/chat/domain/models/conversation.dart';
// import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

// class ChatItem extends StatelessWidget {
//   final Conversation conversation;
//   final MyplugUser otherUser;
//   final VoidCallback? onTap;

//   const ChatItem({
//     super.key,
//     required this.conversation,
//     required this.otherUser,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final time = conversation.lastSentAt != null
//         ? DateFormat('hh:mm a').format(conversation.lastSentAt!)
//         : '';

//     return ListTile(
//       onTap: onTap,
//       leading: CircleAvatar(
//         backgroundImage: otherUser.image == null
//             ? const AssetImage(noUserImage)
//             : NetworkImage(otherUser.image!),
//       ),
//       title: Text(otherUser.fullname),
//       subtitle: Text(conversation.lastMessage ?? ''),
//       trailing: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
//           if (conversation.unreadCount > 0)
//             Container(
//               margin: const EdgeInsets.only(top: 4),
//               padding: const EdgeInsets.all(6),
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.red,
//               ),
//               child: Text(
//                 '${conversation.unreadCount}',
//                 style: const TextStyle(color: Colors.white, fontSize: 10),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
// lib/features/chat/views/widgets/chat_item.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myplug_ca/core/constants/images.dart';
import 'package:myplug_ca/features/chat/domain/models/chat_message.dart';
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

    final hasUnread = conversation.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            // Avatar with unread indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: otherUser.image == null
                      ? const AssetImage(noUserImage) as ImageProvider
                      : NetworkImage(otherUser.image!),
                ),
                if (hasUnread)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Name + Last message + Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUser.fullname,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Show message status only if current user sent last message
                      if (conversation.isLastMessageFromCurrentUser)
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: _buildMessageStatus(
                              conversation.lastMessageStatus),
                        ),

                      // Last message preview
                      Expanded(
                        child: Text(
                          conversation.lastMessage ?? '',
                          style: TextStyle(
                            color: hasUnread ? Colors.black : Colors.grey[600],
                            fontWeight:
                                hasUnread ? FontWeight.w500 : FontWeight.normal,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Time + unread badge
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (hasUnread)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${conversation.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds WhatsApp-style checkmarks
  Widget _buildMessageStatus(MessageStatus? status) {
    switch (status) {
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 16, color: Colors.grey);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 16, color: Colors.grey);
      case MessageStatus.seen:
        return const Icon(Icons.done_all, size: 16, color: Colors.blue);
      default:
        return const SizedBox.shrink();
    }
  }
}
