import 'package:flutter/material.dart';
import 'package:myplug_ca/core/constants/conversations.dart';
import 'package:myplug_ca/core/constants/users.dart';
import 'package:myplug_ca/features/chat/presentation/ui/pages/messagepage.dart';
import 'package:myplug_ca/features/chat/presentation/ui/widgets/chat_item.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

String searchQuery = '';

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    const currentUserId = '1';

    final filteredConversations = demoConversations.where((convo) {
      final otherId =
          convo.participants.firstWhere((id) => id != currentUserId);
      final user = demoUsers.firstWhere((u) => u.id == otherId);
      final name = '${user.firstName} ${user.lastName}'.toLowerCase();
      return name.contains(searchQuery.toLowerCase()) ||
          (convo.lastMessage
                  ?.toLowerCase()
                  .contains(searchQuery.toLowerCase()) ??
              false);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search chats...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredConversations.length,
              itemBuilder: (context, index) {
                final convo = filteredConversations[index];
                final otherId =
                    convo.participants.firstWhere((id) => id != currentUserId);
                final otherUser = demoUsers.firstWhere((u) => u.id == otherId);
                return ChatItem(
                  conversation: convo,
                  otherUser: otherUser,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => MessagePage(
                            currentUserId: currentUserId,
                            otherUser: otherUser,
                            messages: [])));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
