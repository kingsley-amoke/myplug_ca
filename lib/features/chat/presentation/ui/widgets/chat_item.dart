import 'package:flutter/material.dart';
import 'package:myplug_ca/features/chat/domain/models/conversation.dart';
import 'package:myplug_ca/features/chat/presentation/ui/pages/messagepage.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

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
    final me = context.read<UserProvider>().myplugUser!.id!;
    final unread = conversation.unreadCounts[me] ?? 0;
    final typing = conversation.typing[otherUser.id] == true;
    final subtitle = typing ? 'typing…' : (conversation.lastMessage ?? '');

    return ListTile(
      leading: CircleAvatar(
        child: otherUser.image != null
            ? ClipOval(
                child: Image.network(otherUser.image!),
              )
            : Text(otherUser.fullname[0].toUpperCase()),
      ),
      title: Text(otherUser.fullname),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontStyle: typing ? FontStyle.italic : FontStyle.normal,
          color: typing ? Colors.green : null,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (conversation.lastSentAt != null)
            Text(_friendlyTime(conversation.lastSentAt!),
                style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          if (unread > 0)
            CircleAvatar(
              radius: 10,
              backgroundColor: Colors.green,
              child: Text(
                '$unread',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              conversationId: conversation.id,
              otherUser: otherUser,
            ),
          ),
        );
      },
    );
  }
}

String _friendlyTime(DateTime t) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final thatDay = DateTime(t.year, t.month, t.day);
  if (thatDay == today) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }
  return '${t.day}/${t.month}/${t.year % 100}';
}
