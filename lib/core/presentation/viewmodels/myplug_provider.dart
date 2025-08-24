import 'package:flutter/widgets.dart';
import 'package:myplug_ca/features/chat/data/repositories/chat_repo_impl.dart';
import 'package:myplug_ca/features/chat/domain/models/conversation.dart';
import 'package:myplug_ca/features/job/data/repositories/job_repo_impl.dart';
import 'package:myplug_ca/features/product/data/repositories/product_repo_impl.dart';
import 'package:myplug_ca/features/product/domain/models/product.dart';
import 'package:myplug_ca/features/promotion/data/repositories/promotion_repo_impl.dart';
import 'package:myplug_ca/features/promotion/domain/models/promotion.dart';
import 'package:myplug_ca/features/subscription/data/repositories/subscription_repo_impl.dart';
import 'package:myplug_ca/features/subscription/domain/models/subscription.dart';
import 'package:myplug_ca/features/user/data/repositories/user_repo_impl.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/domain/models/transaction.dart';
import 'package:uuid/uuid.dart';

class MyplugProvider extends ChangeNotifier {
  final ChatRepoImpl chatRepoImpl;
  final UserRepoImpl userRepoImpl;
  final ProductRepoImpl productRepoImpl;
  final JobRepoImpl jobRepoImpl;
  final SubscriptionRepoImpl subscriptionRepoImpl;
  final PromotionRepoImpl promotionRepoImpl;

  MyplugProvider({
    required this.jobRepoImpl,
    required this.subscriptionRepoImpl,
    required this.userRepoImpl,
    required this.productRepoImpl,
    required this.chatRepoImpl,
    required this.promotionRepoImpl,
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

    //create transaction
    final Transaction transaction = Transaction(
      id: Uuid().v4(),
      type: TransactionType.debit,
      description: 'Subscription charges',
      amount: subscription.plan.price,
      date: DateTime.now(),
    );

    updatedUser.transactions.add(transaction);

    final trnx = updatedUser.transactions;

    //save subscription
    subscriptionRepoImpl.createSubscription(subscription);

    //update user
    userRepoImpl.updateProfile(updatedUser.copyWith(transactions: trnx));

    return true;
  }

  //cancel subscription

  //promote product
  Future<bool> promoteProduct({
    required MyplugUser user,
    required Product product,
    required Promotion promotion,
  }) async {
    //charge user wallet

    final updatedUser = userRepoImpl.deductUserBalance(
        user: user, amount: promotion.plan.price);

    if (updatedUser == null) {
      return false;
    }

    //create transaction
    final Transaction transaction = Transaction(
      id: Uuid().v4(),
      type: TransactionType.debit,
      description: 'Product promotion',
      amount: promotion.plan.price,
      date: DateTime.now(),
    );

    updatedUser.transactions.add(transaction);

    final trnx = updatedUser.transactions;

    //save promotion
    promotionRepoImpl.createPromotion(promotion);

    //update product
    productRepoImpl.updateProduct(
      product.copyWith(isPromoted: true),
    );

    //update user
    userRepoImpl.updateProfile(updatedUser.copyWith(transactions: trnx));

    return true;
  }

  //delete product

  //add product

  //cancel promotion
  Future<void> checkAndCancelPromotions() async {}
}
