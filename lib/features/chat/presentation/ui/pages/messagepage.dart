// import 'package:flutter/material.dart';
// import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
// import 'package:myplug_ca/features/chat/domain/models/chat_message.dart';
// import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

// class MessagePage extends StatelessWidget {
//   final String currentUserId;
//   final MyplugUser otherUser;
//   final List<ChatMessage> messages;

//   const MessagePage(
//       {super.key,
//       required this.currentUserId,
//       required this.otherUser,
//       required this.messages});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: myAppbar(context, title: otherUser.fullname ?? 'Chat'),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               reverse: false,
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final msg = messages[messages.length - 1 - index];
//                 final isMine = msg.senderId == currentUserId;

//                 return Align(
//                   alignment:
//                       isMine ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin:
//                         const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: isMine ? Colors.blueAccent : Colors.grey[700],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       msg.content,
//                       style: const TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 const Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Type a message',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () {
//                     // TODO: Send logic
//                   },
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/chat/domain/models/chat_message.dart';
import 'package:myplug_ca/features/chat/presentation/viewmodels/chat_provider.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class MessagePage extends StatefulWidget {
  final String currentUserId;
  final MyplugUser otherUser;
  final String conversationId;

  const MessagePage({
    super.key,
    required this.currentUserId,
    required this.otherUser,
    required this.conversationId,
  });

  @override
  State<MessagePage> createState() => _MessagePageState();
}

final messageController = TextEditingController();

class _MessagePageState extends State<MessagePage> {
  @override
  void initState() {
    super.initState();

    // When user enters chat, mark all as seen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ChatProvider>()
          .markMessagesAsSeen(widget.conversationId, widget.currentUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: widget.otherUser.fullname ?? 'Chat'),
      body: Column(
        children: [
          /// MESSAGES
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
                stream: context.watch<ChatProvider>().loadMessage(
                    conversationId: widget.conversationId,
                    currentUserId:
                        context.read<UserProvider>().myplugUser!.id!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!;
                  return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    reverse: true, // new messages at bottom
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMine = msg.senderId == widget.currentUserId;

                      return Align(
                        alignment: isMine
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isMine
                                  ? const Color(
                                      0xFFDAA579) // your theme’s primary
                                  : Colors.grey.shade800,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: isMine
                                    ? const Radius.circular(16)
                                    : const Radius.circular(0),
                                bottomRight: isMine
                                    ? const Radius.circular(0)
                                    : const Radius.circular(16),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(50),
                                  blurRadius: 2,
                                  offset: const Offset(1, 2),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        msg.content,
                                        softWrap: true,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    // if (isMine) _buildStatusIcon(msg.status),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('hh:mm a').format(msg.timestamp),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),

          /// INPUT FIELD
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    color: Colors.grey[600],
                    onPressed: () {
                      // attach file / media
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFDAA579), // primary color
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        final message = ChatMessage(
                          senderId: widget.currentUserId,
                          receiverId: widget.otherUser.id!,
                          content: messageController.text,
                          timestamp: DateTime.now(),
                        );

                        context
                            .read<ChatProvider>()
                            .sendMessage(
                              message: message,
                              conversationId: widget.conversationId,
                            )
                            .then((_) {
                          messageController.clear();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildStatusIcon(MessageStatus status) {
  switch (status) {
    case MessageStatus.sending:
      return const Icon(Icons.access_time, size: 14, color: Colors.grey);
    case MessageStatus.sent:
      return const Icon(Icons.check, size: 14, color: Colors.grey);
    case MessageStatus.delivered:
      return const Icon(Icons.done_all, size: 14, color: Colors.grey);
    case MessageStatus.seen:
      return const Icon(Icons.done_all, size: 14, color: Colors.blueAccent);
  }
}
