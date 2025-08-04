import 'package:flutter/foundation.dart';
import 'package:myplug_ca/features/chat/data/chat_repo_impl.dart';
import 'package:myplug_ca/features/chat/domain/models/conversation.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepoImpl _chatRepoImpl;

  ChatProvider(this._chatRepoImpl);

  List<Conversation> _userChats = [];

  List<Conversation> get userChats => _userChats;

  //send message

  //delete message

  //create conversation

  //delete conversation
}
