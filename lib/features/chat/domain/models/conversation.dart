class Conversation {
  final String? id;
  final List<String> participants;
  final String? lastMessage;
  final DateTime? lastSentAt;
  final int unreadCount;

  Conversation({
    this.id,
    required this.participants,
    this.lastMessage,
    this.lastSentAt,
    this.unreadCount = 0,
  });

  factory Conversation.fromMap(Map<String, dynamic> map, String id) {
    return Conversation(
      id: id,
      participants: List<String>.from(map['participants']),
      lastMessage: map['last_message'],
      unreadCount: map['unread_count'],
      lastSentAt: map['last_sent_at'] != null
          ? DateTime.parse(map['last_sent_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'participants': participants,
        'last_message': lastMessage,
        'last_sent_at': lastSentAt,
        'unread_count': unreadCount,
      };

  Conversation copyWith(
      {String? lastMessage,
      DateTime? lastSentAt,
      String? id,
      int? unreadCount}) {
    return Conversation(
      id: id ?? this.id,
      participants: participants,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessage: lastMessage ?? this.lastMessage,
      lastSentAt: lastSentAt ?? this.lastSentAt,
    );
  }
}
