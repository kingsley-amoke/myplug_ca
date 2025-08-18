// class ChatMessage {
//   final String? id;
//   final String senderId;
//   final String receiverId;
//   final String content;
//   final DateTime timestamp;
//   final bool seen;

//   ChatMessage({
//     this.id,
//     required this.senderId,
//     required this.receiverId,
//     required this.content,
//     required this.timestamp,
//     this.seen = false,
//   });

//   factory ChatMessage.fromMap(Map<String, dynamic> map, String id) {
//     return ChatMessage(
//       id: id,
//       senderId: map['sender_id'],
//       receiverId: map['receiver_id'],
//       content: map['content'],
//       timestamp: DateTime.parse(map['timestamp']),
//       seen: map['seen'] ?? false,
//     );
//   }

//   Map<String, dynamic> toMap() => {
//         'sender_id': senderId,
//         'receiver_id': receiverId,
//         'content': content,
//         'timestamp': timestamp.toIso8601String(),
//         'seen': seen,
//       };

//   ChatMessage copyWith({
//     String? content,
//     bool? seen,
//     String? id,
//   }) {
//     return ChatMessage(
//       id: id,
//       senderId: senderId,
//       receiverId: receiverId,
//       content: content ?? this.content,
//       timestamp: timestamp,
//       seen: seen ?? this.seen,
//     );
//   }
// }

enum MessageStatus { sending, sent, delivered, seen }

class ChatMessage {
  final String? id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final MessageStatus status;

  ChatMessage({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.status = MessageStatus.sending,
  });

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    DateTime? timestamp,
    MessageStatus? status,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map, String id) {
    return ChatMessage(
      id: id,
      senderId: map['sender_id'],
      receiverId: map['receiver_id'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
      status: MessageStatus.values.firstWhere(
        (e) => e.toString() == 'MessageStatus.${map['status']}',
        orElse: () => MessageStatus.sending,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
    };
  }
}
