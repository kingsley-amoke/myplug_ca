import 'package:flutter/foundation.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/features/chat/data/repositories/chat_repo_impl.dart';
import 'package:myplug_ca/features/chat/domain/models/chat_message.dart';
import 'package:myplug_ca/features/chat/domain/models/conversation.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepoImpl _chatRepoImpl;

  ChatProvider(this._chatRepoImpl);

  List<Conversation> _userChats = [];

  List<Conversation> get userChats => _userChats;

  List<Conversation> filteredConversations = [];

  void initUserConversations(List<Conversation> conversations) {
    _userChats = conversations;
    filteredConversations = conversations;

    // notifyListeners();
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
    print(filteredConversations.length);
    notifyListeners();
    return filteredConversations;
  }

  void onOpenConversation(Conversation conversation) {
    conversation.unreadCount = 0;
    notifyListeners();
  }

  //load message
  Stream<List<ChatMessage>> loadMessage(
      {required String conversationId, required String currentUserId}) {
    return _chatRepoImpl.getMessageStream(
        conversationId: conversationId, currentUserId: currentUserId);
  }

  //send message

  Future<void> sendMessage(
      {required ChatMessage message, required String conversationId}) async {
    await _chatRepoImpl.sendMessage(
      message: message,
      conversationId: conversationId,
    );
  }

  Future<void> markMessagesAsSeen(
      String conversationId, String currentUserId) async {
    return await _chatRepoImpl.markMessagesAsSeen(
        conversationId, currentUserId);
  }

  //delete message

  //create conversation
  Future<String> createConversation(
      {required String senderId, required String receiverId}) async {
    final conversationId =
        createConversationId(senderId: senderId, receiverId: receiverId);
    await _chatRepoImpl.createConversation(conversationId);
    return conversationId;
  }
  //delete conversation
}
