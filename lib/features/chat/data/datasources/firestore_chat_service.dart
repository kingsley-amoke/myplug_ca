import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myplug_ca/features/chat/domain/models/chat_message.dart';
import 'package:myplug_ca/features/chat/domain/models/conversation.dart';
import 'package:myplug_ca/features/chat/domain/repositories/chat_repository.dart';

class FirestoreChatService extends ChatRepository {
  final FirebaseFirestore _firestore;

  FirestoreChatService(this._firestore);

  @override
  Future<String> createConversation({
    required String conversationId,
    required String myId,
    required String otherId,
  }) async {
    final ref = _firestore.collection('conversations').doc(conversationId);
    final snap = await ref.get();
    if (!snap.exists) {
      await ref.set({
        'participants': [myId, otherId],
        'lastMessage': null,
        'lastSentAt': null,
        'unreadCounts': {myId: 0, otherId: 0},
        'typing': {myId: false, otherId: false},
      });
    }

    return conversationId;
  }

  @override
  Future<Conversation> getConversation(String conversationId) async {
    final doc = await _firestore.collection('chats').doc(conversationId).get();
    if (!doc.exists) {
      throw Exception('Conversation not found');
    }
    return Conversation.fromMap(doc.data()!, doc.id);
  }

  @override
  Future<List<Conversation>> getUserConversations(String userId) async {
    final snapshot = await _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('last_sent_at', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Conversation.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> deteleConversation(String conversationId) async {
    final convoRef = _firestore.collection('chats').doc(conversationId);

    // Delete messages first (subcollection)
    final messages = await convoRef.collection('messages').get();
    for (final doc in messages.docs) {
      await doc.reference.delete();
    }

    // Then delete the conversation itself
    await convoRef.delete();
  }

  @override
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
    required String conversationId,
  }) async {
    final convRef = _firestore.collection('conversations').doc(conversationId);
    final msgRef = convRef.collection('messages').doc();

    await _firestore.runTransaction((tx) async {
      tx.set(msgRef, {
        'senderId': senderId,
        'text': text,
        'sentAt': FieldValue.serverTimestamp(),
        'status': 'sent',
      });
      tx.update(convRef, {
        'lastMessage': text,
        'lastSentAt': FieldValue.serverTimestamp(),
        'unreadCounts.$receiverId': FieldValue.increment(1),
        // mark sender typing false on send
        'typing.$senderId': false,
      });
    });
  }

  @override
  Stream<List<Conversation>> getUserConversationsStream(String userId) {
    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: userId)
        .orderBy('lastSentAt', descending: true)
        .snapshots()
        .map((s) =>
            s.docs.map((d) => Conversation.fromMap(d.data(), d.id)).toList());
  }

  @override
  Stream<List<ChatMessage>> getMessageStream({
    required String conversationId,
  }) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('sentAt', descending: false)
        .snapshots()
        .map((s) =>
            s.docs.map((d) => ChatMessage.fromMap(d.data(), d.id)).toList());
  }

  @override
  Future<void> deleteMessage({
    required String conversationId,
    required String messageId,
  }) async {
    final messageRef = _firestore
        .collection('chats')
        .doc(conversationId)
        .collection('messages')
        .doc(messageId);

    await messageRef.delete();

    await _firestore.collection('chats').doc(conversationId).update({
      'lastMessage': null,
      'lastSentAt': null,
    });
  }

  @override
  Future<void> markMessagesAsSeen(String conversationId, String userId) async {
    final convRef = _firestore.collection('conversations').doc(conversationId);
    final msgsRef = convRef.collection('messages');

    await _firestore.runTransaction((tx) async {
      tx.update(convRef, {'unreadCounts.$userId': 0});
      // Mark all messages from other as read (idempotent)
      final unread = await msgsRef.where('status', isNotEqualTo: 'read').get();
      for (final d in unread.docs) {
        // Only mark messages not sent by user
        if ((d.data()['senderId'] as String?) != userId) {
          tx.update(d.reference, {'status': 'read'});
        }
      }
    });
  }

  @override
  Future<void> updateTyping({
    required String conversationId,
    required String userId,
    required bool isTyping,
  }) async {
    await _firestore
        .collection('conversations')
        .doc(conversationId)
        .update({'typing.$userId': isTyping});
  }

  @override
  Future<List<ChatMessage>> searchMessages({
    required String conversationId,
    required String query,
    int limit = 200,
  }) async {
    final snap = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .limit(limit)
        .get();

    final all =
        snap.docs.map((d) => ChatMessage.fromMap(d.data(), d.id)).toList();
    return all
        .where((m) => m.text.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
