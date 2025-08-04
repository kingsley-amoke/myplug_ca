class Conversation {
  final String? id;
  final List<String> participants;
  final String? lastMessage;
  final DateTime? lastSentAt;

  Conversation({
    this.id,
    required this.participants,
    this.lastMessage,
    this.lastSentAt,
  });

  factory Conversation.fromMap(Map<String, dynamic> map, String id) {
    return Conversation(
      id: id,
      participants: List<String>.from(map['participants']),
      lastMessage: map['last_message'],
      lastSentAt: map['last_sent_at'] != null
          ? DateTime.parse(map['last_sent_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'participants': participants,
        'last_message': lastMessage,
        'last_sent_at': lastSentAt,
      };

  Conversation copyWith({
    String? lastMessage,
    DateTime? lastSentAt,
    String? id,
  }) {
    return Conversation(
      id: id ?? this.id,
      participants: participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastSentAt: lastSentAt ?? this.lastSentAt,
    );
  }
}
