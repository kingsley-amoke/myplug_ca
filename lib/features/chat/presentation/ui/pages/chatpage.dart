import 'package:flutter/material.dart';
import 'package:myplug_ca/core/constants/conversations.dart';
import 'package:myplug_ca/core/constants/messages.dart';
import 'package:myplug_ca/core/constants/users.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/core/presentation/viewmodels/myplug_provider.dart';
import 'package:myplug_ca/features/chat/domain/models/conversation.dart';
import 'package:myplug_ca/features/chat/presentation/ui/pages/messagepage.dart';
import 'package:myplug_ca/features/chat/presentation/ui/widgets/chat_item.dart';
import 'package:myplug_ca/features/chat/presentation/viewmodels/chat_provider.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

const currentUserId = '1';

void searchConversation(BuildContext context, {required String searchQuery}) {
  if (searchQuery == '') {
    context.read<ChatProvider>().resetFilteredConversatioins();
  }

  context.read<ChatProvider>().filterChat(
      searchQuery: searchQuery, allUsers: demoUsers, userId: currentUserId);
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: "Chats", implyLeading: false),
      body: StreamBuilder<List<Conversation>>(
          stream: context.watch<MyplugProvider>().getUserConversationStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            context.read<ChatProvider>().initUserConversations(snapshot.data!);

            return Column(
              children: [
                // 🔎 Search bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search chats...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => setState(
                        () => searchConversation(context, searchQuery: value)),
                  ),
                ),

                // 💬 Chats List
                Expanded(
                  child: context
                          .read<ChatProvider>()
                          .filteredConversations
                          .isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat_bubble_outline,
                                  size: 60, color: Colors.grey.shade400),
                              const SizedBox(height: 12),
                              Text(
                                "No chats found",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          itemCount: context
                              .read<ChatProvider>()
                              .filteredConversations
                              .length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1, thickness: 0.3),
                          itemBuilder: (context, index) {
                            final convo = context
                                .read<ChatProvider>()
                                .filteredConversations[index];
                            final otherId = convo.participants
                                .firstWhere((id) => id != currentUserId);
                            final otherUser =
                                demoUsers.firstWhere((u) => u.id == otherId);

                            return ChatItem(
                              conversation: convo,
                              otherUser: otherUser,
                              onTap: () {
                                context
                                    .read<ChatProvider>()
                                    .onOpenConversation(convo);
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => MessagePage(
                                    currentUserId: currentUserId,
                                    otherUser: otherUser,
                                    conversationId: convo.id!,
                                  ),
                                ));
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }),
    );
  }
}
