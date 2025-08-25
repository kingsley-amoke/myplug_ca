import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fixnbuy/core/presentation/ui/widgets/modular_search_filter_bar.dart';
import 'package:fixnbuy/core/presentation/ui/widgets/my_appbar.dart';
import 'package:fixnbuy/features/chat/domain/models/conversation.dart';
import 'package:fixnbuy/features/chat/presentation/ui/widgets/chat_item.dart';
import 'package:fixnbuy/features/chat/presentation/viewmodels/chat_provider.dart';
import 'package:fixnbuy/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class ConversationListScreen extends StatelessWidget {
  const ConversationListScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ChatProvider>();

    final userId = context.read<UserProvider>().myplugUser?.id! ??
        FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: myAppbar(context, title: 'Chats', implyLeading: false),
      body: StreamBuilder<List<Conversation>>(
        stream: repo.conversationsFor(userId),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final conversations = snap.data!;
          repo.initUserConversations(conversations);

          // repo.calculateTotalUnread(conversations, userId);

          if (conversations.isEmpty) {
            return const Center(child: Text('No conversations yet'));
          }

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
                          allUsers: userProvider
                              .allUsers, // final other = conversation.participants.firstWhere((p) => p != me);
                          userId: userProvider.myplugUser!.id!,
                        );
                  },
                ),
              ),
              Flexible(
                child: Consumer<ChatProvider>(
                  builder: (context, provider, _) {
                    return ListView.separated(
                      itemCount: provider.filteredConversations.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        thickness: 0.3,
                      ),
                      itemBuilder: (context, i) {
                        final c = provider.filteredConversations[i];

                        final other =
                            c.participants.firstWhere((p) => p != userId);

                        final otherUser = context
                            .read<UserProvider>()
                            .allUsers
                            .firstWhere((u) => u.id == other);
                        return ChatItem(
                          conversation: c,
                          otherUser: otherUser,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
