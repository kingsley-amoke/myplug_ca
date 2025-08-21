import 'package:myplug_ca/features/chat/domain/models/chat_message.dart';

class Conversation {
  final String? id;
  final List<String> participants;
  final String? lastMessage;
  final DateTime? lastSentAt;
  int unreadCount;
  final bool isLastMessageFromCurrentUser;
  final MessageStatus? lastMessageStatus;

  Conversation({
    this.id,
    required this.participants,
    this.lastMessage,
    this.lastSentAt,
    this.unreadCount = 0,
    this.isLastMessageFromCurrentUser = false,
    this.lastMessageStatus,
  });

  void set(int count) {
    unreadCount = count;
  }

  factory Conversation.fromMap(Map<String, dynamic> map, String id) {
    return Conversation(
      id: id,
      participants: List<String>.from(map['participants']),
      lastMessage: map['last_message'],
      unreadCount: map['unread_count'] ?? 0,
      lastSentAt: map['last_sent_at'] != null
          ? DateTime.tryParse(map['last_sent_at'])
          : null,
      isLastMessageFromCurrentUser:
          map['is_last_message_from_current_user'] ?? false,
      lastMessageStatus: _statusFromString(map['last_message_status']),
    );
  }

  Map<String, dynamic> toMap() => {
        'participants': participants,
        'last_message': lastMessage,
        'last_sent_at': lastSentAt?.toIso8601String(),
        'unread_count': unreadCount,
        'is_last_message_from_current_user': isLastMessageFromCurrentUser,
        'last_message_status': lastMessageStatus?.name,
      };

  Conversation copyWith({
    String? id,
    List<String>? participants,
    String? lastMessage,
    DateTime? lastSentAt,
    int? unreadCount,
    bool? isLastMessageFromCurrentUser,
    MessageStatus? lastMessageStatus,
  }) {
    return Conversation(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastSentAt: lastSentAt ?? this.lastSentAt,
      unreadCount: unreadCount ?? this.unreadCount,
      isLastMessageFromCurrentUser:
          isLastMessageFromCurrentUser ?? this.isLastMessageFromCurrentUser,
      lastMessageStatus: lastMessageStatus ?? this.lastMessageStatus,
    );
  }

  static MessageStatus? _statusFromString(String? status) {
    switch (status) {
      case 'sent':
        return MessageStatus.sent;
      case 'delivered':
        return MessageStatus.delivered;
      case 'seen':
        return MessageStatus.seen;
      default:
        return null;
    }
  }
}
