import 'package:flutter/material.dart';
import 'package:myplug_ca/features/chat/domain/models/chat_message.dart';
import 'package:myplug_ca/features/chat/presentation/ui/widgets/input_bar.dart';
import 'package:myplug_ca/features/chat/presentation/ui/widgets/typing_item.dart';
import 'package:myplug_ca/features/chat/presentation/viewmodels/chat_provider.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  final MyplugUser otherUser;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.otherUser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _input = TextEditingController();
  final TextEditingController _search = TextEditingController();
  bool _searchMode = false;
  List<ChatMessage> _searchResults = [];
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatProvider>().markAsRead(
          conversationId: widget.conversationId,
          userId: context.read<UserProvider>().myplugUser!.id!,
        );
  }

  @override
  void dispose() {
    _input.dispose();
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _doSend() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    await context.read<ChatProvider>().sendText(
          conversationId: widget.conversationId,
          senderId: context.read<UserProvider>().myplugUser!.id!,
          receiverId: widget.otherUser.id!,
          text: text,
        );
    _input.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scroll.hasClients) {
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _onTypingChanged(String v) {
    context.read<ChatProvider>().updateTyping(
          conversationId: widget.conversationId,
          userId: context.read<UserProvider>().myplugUser!.id!,
          isTyping: v.isNotEmpty,
        );
  }

  Future<void> _runSearch() async {
    final q = _search.text.trim();
    if (q.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    final r = await context.read<ChatProvider>().searchMessages(
          conversationId: widget.conversationId,
          query: q,
          limit: 400,
        );
    setState(() => _searchResults = r);
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ChatProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.chevron_left)),
        title: _searchMode
            ? TextField(
                controller: _search,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search messages',
                  border: InputBorder.none,
                ),
                onChanged: (_) => _runSearch(),
              )
            : Row(
                children: [
                  CircleAvatar(
                    child: widget.otherUser.image != null
                        ? ClipOval(
                            child: Image.network(widget.otherUser.image!),
                          )
                        : Text(widget.otherUser.fullname[0].toUpperCase()),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.otherUser.fullname),
                      TypingIndicator(
                        conversationId: widget.conversationId,
                        otherUserId: widget.otherUser.id!,
                      ),
                    ],
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(_searchMode ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _searchMode = !_searchMode;
                _searchResults = [];
                _search.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_searchMode)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              alignment: Alignment.centerLeft,
              child: Text(
                _searchResults.isEmpty
                    ? 'Type to search…'
                    : 'Found ${_searchResults.length} message(s)',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: repo.messages(widget.conversationId),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snap.data!;
                // auto-mark as read when viewing
                repo.markAsRead(
                  conversationId: widget.conversationId,
                  userId: context.read<UserProvider>().myplugUser!.id!,
                );

                return ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final m = messages[i];
                    final isMe = m.senderId ==
                        context.read<UserProvider>().myplugUser!.id!;
                    final highlight = _searchMode &&
                        _search.text.isNotEmpty &&
                        m.text
                            .toLowerCase()
                            .contains(_search.text.toLowerCase());

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.fromLTRB(12, 8, 10, 6),
                          decoration: BoxDecoration(
                            color: isMe
                                ? const Color(0xFFD2F8D2)
                                : const Color(0xFFEDEDED),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: Radius.circular(isMe ? 12 : 2),
                              bottomRight: Radius.circular(isMe ? 2 : 12),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (highlight)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Match',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              Text(m.text),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _timeShort(m.sentAt),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  if (isMe) ...[
                                    const SizedBox(width: 6),
                                    _statusIcon(m.status),
                                  ]
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          InputBar(
            controller: _input,
            onChanged: _onTypingChanged,
            onSend: _doSend,
          ),
        ],
      ),
    );
  }
}

Widget _statusIcon(MessageStatus s) {
  switch (s) {
    case MessageStatus.sent:
      return const Icon(Icons.check, size: 16, color: Colors.grey);
    case MessageStatus.delivered:
      return const Icon(Icons.done_all, size: 18, color: Colors.grey);
    case MessageStatus.read:
      return const Icon(Icons.done_all, size: 18, color: Colors.blue);
  }
}

String _timeShort(DateTime t) {
  final h = t.hour.toString().padLeft(2, '0');
  final m = t.minute.toString().padLeft(2, '0');
  return '$h:$m';
}
