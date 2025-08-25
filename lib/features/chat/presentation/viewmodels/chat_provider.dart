import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fixnbuy/features/chat/data/repositories/chat_repo_impl.dart';
import 'package:fixnbuy/features/chat/domain/models/chat_message.dart';
import 'package:fixnbuy/features/chat/domain/models/conversation.dart';
import 'package:fixnbuy/features/user/domain/models/myplug_user.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepoImpl _chatRepoImpl;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  ChatProvider(this._chatRepoImpl);

  List<Conversation> _userChats = [];

  List<Conversation> get userChats => _userChats;

  List<Conversation> filteredConversations = [];

  num totalUnread = 0;

  void initUserConversations(List<Conversation> conversations) {
    _userChats = conversations;
    filteredConversations = conversations;
    // calculateTotalUnread(userId);

    // notifyListeners();
  }

  void setTotalUnread(num value) {
    totalUnread = value;
    print(value);
    notifyListeners();
  }

  void calculateTotalUnread(List<Conversation> conversations, String id) {
    int total = 0;
    for (final c in conversations) {
      final unread = c.unreadCounts[id] ?? 0;
      total += unread;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      totalUnread = total;
      notifyListeners();
    });
  }

  List<Conversation> searchConversations({
    required String search,
    required List<MyplugUser> allUsers,
    required String userId,
  }) {
    // ✅ Restore all conversations if search is empty
    if (search.trim().isEmpty) {
      filteredConversations = List<Conversation>.from(_userChats);
      notifyListeners();
      return filteredConversations;
    }

    final term = search.toLowerCase();
    List<Conversation> matches = [];

    for (Conversation convo in _userChats) {
      final otherId = convo.participants.firstWhere((id) => id != userId);
      final user = allUsers.firstWhere((u) => u.id == otherId);
      final name = user.fullname.toLowerCase();
      final lastMessage = convo.lastMessage?.toLowerCase() ?? '';

      if (lastMessage.contains(term) || name.contains(term)) {
        matches.add(convo);
      }
    }

    filteredConversations = matches;

    notifyListeners();
    return filteredConversations;
  }

  Future<void> markMessagesAsSeen(
      String conversationId, String currentUserId) async {
    return await _chatRepoImpl.markMessagesAsSeen(
        conversationId, currentUserId);
  }

  String conversationIdFor(String a, String b) {
    final ids = [a, b]..sort();
    return ids.join('_');
  }

  Future<String> createOrGetConversation(String me, String other) async {
    final id = conversationIdFor(me, other);

    _chatRepoImpl.createConversation(
      conversationId: id,
      myId: me,
      otherId: other,
    );

    return id;
  }

  Stream<List<Conversation>> conversationsFor(String userId) {
    return _chatRepoImpl.getUserConversationsStream(userId);
  }

  Stream<List<ChatMessage>> messages(String conversationId) {
    return _chatRepoImpl.getMessageStream(conversationId: conversationId);
  }

  Future<void> sendText({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    await _chatRepoImpl.sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
    );
  }

  Future<void> markAsRead({
    required String conversationId,
    required String userId,
  }) async {
    await _chatRepoImpl.markMessagesAsSeen(conversationId, userId);
  }

  Future<void> updateTyping({
    required String conversationId,
    required String userId,
    required bool isTyping,
  }) async {
    await _db
        .collection('conversations')
        .doc(conversationId)
        .update({'typing.$userId': isTyping});
  }

  /// Search messages by text (simple client-side contains after fetching).
  /// For large chats, consider Firestore full-text via a search service.
  Future<List<ChatMessage>> searchMessages({
    required String conversationId,
    required String query,
    int limit = 200,
  }) async {
    return await _chatRepoImpl.searchMessages(
      conversationId: conversationId,
      query: query,
    );
  }
}
