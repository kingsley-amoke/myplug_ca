import 'package:flutter/widgets.dart';
import 'package:myplug_ca/features/chat/data/repositories/chat_repo_impl.dart';
import 'package:myplug_ca/features/chat/domain/models/conversation.dart';
import 'package:myplug_ca/features/job/data/repositories/job_repo_impl.dart';
import 'package:myplug_ca/features/product/data/repositories/product_repo_impl.dart';
import 'package:myplug_ca/features/subscription/data/repositories/subscription_repo_impl.dart';
import 'package:myplug_ca/features/subscription/domain/models/subscription.dart';
import 'package:myplug_ca/features/user/data/repositories/user_repo_impl.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

class MyplugProvider extends ChangeNotifier {
  final ChatRepoImpl chatRepoImpl;
  final UserRepoImpl userRepoImpl;
  final ProductRepoImpl productRepoImpl;
  final JobRepoImpl jobRepoImpl;
  final SubscriptionRepoImpl subscriptionRepoImpl;

  MyplugProvider({
    required this.jobRepoImpl,
    required this.subscriptionRepoImpl,
    required this.userRepoImpl,
    required this.productRepoImpl,
    required this.chatRepoImpl,
  });

  //purchase product

  //contact user

  //apply job

  //subscribe
  Future<bool> subscribeUser(
      {required MyplugUser user, required Subscription subscription}) async {
    //charge user wallet

    final updatedUser = userRepoImpl.deductUserBalance(
        user: user, amount: subscription.plan.price);

    if (updatedUser == null) {
      return false;
    }

    //save subscription
    subscriptionRepoImpl.createSubscription(subscription);

    //update user
    userRepoImpl.updateProfile(user);

    return true;
  }

  //cancel subscription

  //promote product

  //delete product

  //add product

  //cancel promotion

  //suspend user

  //make user admin

  //delete user

  //delete chat

  //get user conversation
  Stream<List<Conversation>> getUserConversationStream() {
    return chatRepoImpl
        .getUserConversationsStream(userRepoImpl.currentUser!.id!);
  }
}
