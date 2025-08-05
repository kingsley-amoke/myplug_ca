import 'package:myplug_ca/features/chat/domain/models/conversation.dart';

final List<Conversation> demoConversations = [
  Conversation(
    id: '1_2',
    participants: ['1', '2'],
    lastMessage: 'Hey, how are you?',
    lastSentAt: DateTime.now().subtract(const Duration(minutes: 10)),
    unreadCount: 3,
  ),
  Conversation(
    id: '1_3',
    participants: ['1', '3'],
    lastMessage: 'Let’s connect tomorrow!',
    lastSentAt: DateTime.now().subtract(const Duration(hours: 1)),
  ),
];
