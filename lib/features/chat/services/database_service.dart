import 'package:myplug_ca/features/chat/domain/models/chat_message.dart';
import 'package:myplug_ca/features/chat/domain/models/conversation.dart';
import 'package:myplug_ca/features/chat/domain/repositories/chat_repository.dart';

class ChatDatabaseService extends ChatRepository {
  final ChatRepository _databaseService;

  ChatDatabaseService(this._databaseService);

  @override
  Future<String> createConversation(String conversationId) async {
    return await _databaseService.createConversation(conversationId);
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
  Future<void> sendMessage(
      {required ChatMessage message, required String conversationId}) async {
    return await _databaseService.sendMessage(
        message: message, conversationId: conversationId);
  }

  @override
  Stream<List<Conversation>> getUserConversationsStream(String userId) {
    return _databaseService.getUserConversationsStream(userId);
  }

  @override
  Stream<List<ChatMessage>> getMessageStream(
      {required String conversationId, required String currentUserId}) {
    return _databaseService.getMessageStream(
        conversationId: conversationId, currentUserId: currentUserId);
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
}
