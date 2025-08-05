import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/chat/domain/models/chat_message.dart';
import 'package:myplug_ca/features/product/presentation/ui/pages/product_details.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

class MessagePage extends StatelessWidget {
  final String currentUserId;
  final MyplugUser otherUser;
  final List<ChatMessage> messages;

  const MessagePage(
      {super.key,
      required this.currentUserId,
      required this.otherUser,
      required this.messages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: otherUser.fullname ?? 'Chat'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[messages.length - 1 - index];
                final isMine = msg.senderId == currentUserId;

                return Align(
                  alignment:
                      isMine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMine ? Colors.blueAccent : Colors.grey[700],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.content,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // TODO: Send logic
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
