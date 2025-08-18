import 'package:myplug_ca/features/chat/domain/models/chat_message.dart';
import 'package:myplug_ca/features/chat/domain/models/conversation.dart';

abstract class ChatRepository {
  Future<String> createConversation(String conversationId);
  Future<Conversation> getConversation(String conversationId);
  Future<List<Conversation>> getUserConversations(String userId);
  Future<void> deteleConversation(String conversationId);
  Future<void> sendMessage(
      {required ChatMessage message, required String conversationId});

  Stream<List<Conversation>> getUserConversationsStream(String userId);
  Stream<List<ChatMessage>> getMessageStream(
      {required String conversationId, required String currentUserId});

  Future<void> deleteMessage({
    required String conversationId,
    required String messageId,
  });

  Future<void> markMessagesAsSeen(String conversationId, String currentUserId);
}
