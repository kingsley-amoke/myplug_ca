// enum MessageStatus { sending, sent, delivered, seen }

// class ChatMessage {
//   final String? id;
//   final String senderId;
//   final String receiverId;
//   final String content;
//   final DateTime timestamp;
//   final MessageStatus status;

//   ChatMessage({
//     this.id,
//     required this.senderId,
//     required this.receiverId,
//     required this.content,
//     required this.timestamp,
//     this.status = MessageStatus.sending,
//   });

//   ChatMessage copyWith({
//     String? id,
//     String? senderId,
//     String? receiverId,
//     String? content,
//     DateTime? timestamp,
//     MessageStatus? status,
//   }) {
//     return ChatMessage(
//       id: id ?? this.id,
//       senderId: senderId ?? this.senderId,
//       receiverId: receiverId ?? this.receiverId,
//       content: content ?? this.content,
//       timestamp: timestamp ?? this.timestamp,
//       status: status ?? this.status,
//     );
//   }

//   factory ChatMessage.fromMap(Map<String, dynamic> map, String id) {
//     return ChatMessage(
//       id: id,
//       senderId: map['sender_id'],
//       receiverId: map['receiver_id'],
//       content: map['content'],
//       timestamp: DateTime.parse(map['timestamp']),
//       status: MessageStatus.values.firstWhere(
//         (e) => e.toString() == 'MessageStatus.${map['status']}',
//         orElse: () => MessageStatus.sending,
//       ),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'sender_id': senderId,
//       'receiver_id': receiverId,
//       'content': content,
//       'timestamp': timestamp.toIso8601String(),
//       'status': status.name,
//     };
//   }
// }

// models/message.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageStatus { sent, delivered, read }

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime sentAt;
  final MessageStatus status;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.sentAt,
    required this.status,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map, String id) {
    return ChatMessage(
      id: id,
      senderId: map['senderId'],
      text: map['text'],
      sentAt: (map['sentAt'] as Timestamp).toDate(),
      status: _statusFromString(map['status']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'sentAt': Timestamp.fromDate(sentAt),
      'status': _statusToString(status),
    };
  }

  static MessageStatus _statusFromString(String s) {
    switch (s) {
      case 'read':
        return MessageStatus.read;
      case 'delivered':
        return MessageStatus.delivered;
      default:
        return MessageStatus.sent;
    }
  }

  static String _statusToString(MessageStatus s) {
    switch (s) {
      case MessageStatus.read:
        return 'read';
      case MessageStatus.delivered:
        return 'delivered';
      default:
        return 'sent';
    }
  }

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? text,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      sentAt: sentAt,
      status: status,
    );
  }
}
