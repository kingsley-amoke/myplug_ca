import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/modular_search_filter_bar.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/core/presentation/viewmodels/myplug_provider.dart';
import 'package:myplug_ca/features/chat/domain/models/conversation.dart';
import 'package:myplug_ca/features/chat/presentation/ui/pages/messagepage.dart';
import 'package:myplug_ca/features/chat/presentation/ui/widgets/chat_item.dart';
import 'package:myplug_ca/features/chat/presentation/viewmodels/chat_provider.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<UserProvider>().myplugUser!.id!;

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ModularSearchFilterBar(
                    showFilterIcon: false,
                    onSearch: (search, _) {
                      final userProvider = context.read<UserProvider>();
                      context.read<ChatProvider>().searchConversations(
                            search: search,
                            allUsers: userProvider.allUsers,
                            userId: userProvider.myplugUser!.id!,
                          );
                    },
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
                      : Consumer<ChatProvider>(
                          builder: (context, provider, _) {
                            return ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              itemCount: provider.filteredConversations.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1, thickness: 0.3),
                              itemBuilder: (context, index) {
                                final convo =
                                    provider.filteredConversations[index];

                                final otherId = convo.participants
                                    .firstWhere((id) => id != currentUserId);

                                final otherUser = context
                                    .read<UserProvider>()
                                    .allUsers
                                    .firstWhere((u) => u.id == otherId);

                                return ChatItem(
                                  conversation: convo,
                                  otherUser: otherUser,
                                  onTap: () {
                                    provider.onOpenConversation(convo);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (_) => MessagePage(
                                        currentUserId: currentUserId,
                                        otherUser: otherUser,
                                        conversationId: convo.id!,
                                      ),
                                    ));
                                  },
                                );
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
