import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myplug_ca/features/chat/domain/models/chat_message.dart';
import 'package:myplug_ca/features/chat/domain/models/conversation.dart';
import 'package:myplug_ca/features/chat/domain/repositories/chat_repository.dart';

class FirestoreChatService extends ChatRepository {
  final FirebaseFirestore _firestore;

  FirestoreChatService(this._firestore);

  @override
  Future<String> createConversation(String conversationId) async {
    final docRef = _firestore.collection('chats').doc(conversationId);
    final exists = (await docRef.get()).exists;

    if (!exists) {
      await docRef.set({
        'id': conversationId,
        'participants': conversationId.split('_'), // Assuming deterministic ID
        'last_message': null,
        'last_sent_at': null,
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
  Future<void> sendMessage(
      {required ChatMessage message, required String conversationId}) async {
    final docRef = _firestore
        .collection('chats')
        .doc(conversationId)
        .collection('messages')
        .doc();

    await docRef.set(message.copyWith(id: conversationId).toMap());

    // Update conversation metadata
    await _firestore.collection('chats').doc(conversationId).update({
      'last_message': message.content,
      'last_sent_at': message.timestamp,
    });
  }

  @override
  Stream<List<Conversation>> getUserConversationsStream(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('last_sent_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Conversation.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Stream<List<ChatMessage>> getMessageStream(String conversationId) {
    return _firestore
        .collection('chats')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data(), doc.id))
            .toList());
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
}
