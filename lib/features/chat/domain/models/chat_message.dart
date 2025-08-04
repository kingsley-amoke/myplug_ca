class ChatMessage {
  final String? id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool seen;

  ChatMessage({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.seen = false,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map, String id) {
    return ChatMessage(
      id: id,
      senderId: map['sender_id'],
      receiverId: map['receiver_id'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
      seen: map['seen'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'sender_id': senderId,
        'receiver_id': receiverId,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'seen': seen,
      };

  ChatMessage copyWith({
    String? content,
    bool? seen,
    String? id,
  }) {
    return ChatMessage(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      content: content ?? this.content,
      timestamp: timestamp,
      seen: seen ?? this.seen,
    );
  }
}
