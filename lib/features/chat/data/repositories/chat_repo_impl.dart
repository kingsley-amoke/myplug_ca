import 'package:myplug_ca/features/chat/domain/models/chat_message.dart';
import 'package:myplug_ca/features/chat/domain/models/conversation.dart';
import 'package:myplug_ca/features/chat/domain/repositories/chat_repository.dart';
import 'package:myplug_ca/features/chat/services/database_service.dart';

class ChatRepoImpl extends ChatRepository {
  final ChatDatabaseService _databaseService;
  ChatRepoImpl(this._databaseService);

  @override
  Future<String> createConversation({
    required String conversationId,
    required String myId,
    required String otherId,
  }) async {
    return await _databaseService.createConversation(
      conversationId: conversationId,
      myId: myId,
      otherId: otherId,
    );
  }

  @override
  Future<Conversation> getConversation(String conversationId) async {
    return await _databaseService.getConversation(conversationId);
  }

  @override
  Future<List<Conversation>> getUserConversations(String userId) async {
    return await _databaseService.getUserConversations(userId);
  }

  @override
  Future<void> deteleConversation(String conversationId) async {
    return await _databaseService.deteleConversation(conversationId);
  }

  @override
  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    return await _databaseService.sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
    );
  }

  @override
  Stream<List<Conversation>> getUserConversationsStream(String userId) {
    return _databaseService.getUserConversationsStream(userId);
  }

  @override
  Stream<List<ChatMessage>> getMessageStream({
    required String conversationId,
  }) {
    return _databaseService.getMessageStream(
      conversationId: conversationId,
    );
  }

  @override
  Future<void> deleteMessage({
    required String conversationId,
    required String messageId,
  }) async {
    return await _databaseService.deleteMessage(
        conversationId: conversationId, messageId: messageId);
  }

  @override
  Future<void> markMessagesAsSeen(
      String conversationId, String currentUserId) async {
    return await _databaseService.markMessagesAsSeen(
        conversationId, currentUserId);
  }

  @override
  Future<void> updateTyping({
    required String conversationId,
    required String userId,
    required bool isTyping,
  }) async {
    return await _databaseService.updateTyping(
      conversationId: conversationId,
      userId: userId,
      isTyping: isTyping,
    );
  }

  @override
  Future<List<ChatMessage>> searchMessages({
    required String conversationId,
    required String query,
    int limit = 200,
  }) async {
    return await _databaseService.searchMessages(
      conversationId: conversationId,
      query: query,
    );
  }
}
