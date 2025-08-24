import 'package:myplug_ca/features/chat/domain/models/chat_message.dart';
import 'package:myplug_ca/features/chat/domain/models/conversation.dart';

abstract class ChatRepository {
  Future<String> createConversation({
    required String conversationId,
    required String myId,
    required String otherId,
  });
  Future<Conversation> getConversation(String conversationId);
  Future<List<Conversation>> getUserConversations(String userId);
  Future<void> deteleConversation(String conversationId);
  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String text,
  });

  Stream<List<Conversation>> getUserConversationsStream(String userId);
  Stream<List<ChatMessage>> getMessageStream({required String conversationId});

  Future<void> deleteMessage({
    required String conversationId,
    required String messageId,
  });

  Future<void> markMessagesAsSeen(String conversationId, String currentUserId);
  Future<void> updateTyping({
    required String conversationId,
    required String userId,
    required bool isTyping,
  });

  Future<List<ChatMessage>> searchMessages({
    required String conversationId,
    required String query,
    int limit = 200,
  });
}
