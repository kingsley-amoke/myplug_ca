import 'package:myplug_ca/features/chat/domain/models/conversation.dart';

final List<Conversation> demoConversations = [
  Conversation(
    id: '1_2',
    participants: ['1', '2'],
    lastMessage: 'Hey, how are you?',
    lastSentAt: DateTime.now().subtract(const Duration(minutes: 10)),
    unreadCount: 3,
    isLastMessageFromCurrentUser: true,
    lastMessageStatus: MessageStatus.read,
  ),
  Conversation(
    id: '1_3',
    participants: ['1', '3'],
    lastMessage: 'Let’s connect tomorrow!',
    lastSentAt: DateTime.now().subtract(const Duration(hours: 1)),
    isLastMessageFromCurrentUser: true,
    lastMessageStatus: MessageStatus.read,
  ),
];

final demoConversationsi = [
  Conversation(
    id: "1_2",
    participants: ["1", "2"], // current user (1) chatting with user 2
    lastMessage: "Hey, how are you?",
    lastSentAt: DateTime.now().subtract(const Duration(minutes: 5)),
    unreadCount: 0,
    isLastMessageFromCurrentUser: true,
    lastMessageStatus: MessageStatus.read,
  ),
  Conversation(
    id: "1_3",
    participants: ["1", "3"],
    lastMessage: "Did you check the update?",
    lastSentAt: DateTime.now().subtract(const Duration(hours: 1)),
    unreadCount: 2,
    isLastMessageFromCurrentUser: true,
    lastMessageStatus: MessageStatus.delivered,
  ),
  Conversation(
    id: "2_3",
    participants: ["1", "4"],
    lastMessage: "Yes, let’s meet tomorrow.",
    lastSentAt: DateTime.now().subtract(const Duration(days: 1)),
    unreadCount: 1,
    isLastMessageFromCurrentUser: false, // message from other user
    lastMessageStatus: null, // not applicable since it's from other user
  ),
  Conversation(
    id: "1_4",
    participants: ["1", "5"],
    lastMessage: "Sending files now...",
    lastSentAt: DateTime.now().subtract(const Duration(minutes: 30)),
    unreadCount: 0,
    isLastMessageFromCurrentUser: true,
    lastMessageStatus: MessageStatus.sent,
  ),
];
