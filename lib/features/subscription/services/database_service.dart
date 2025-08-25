import 'package:fixnbuy/features/subscription/domain/models/subscription.dart';
import 'package:fixnbuy/features/subscription/domain/models/subscription_plan.dart';
import 'package:fixnbuy/features/subscription/domain/repositories/subscription_repo.dart';

class SubscriptionDatabaseService extends SubscriptionRepository {
  final SubscriptionRepository _databaseService;

  SubscriptionDatabaseService(this._databaseService);

  @override
  Future<void> createSubscription(Subscription subscription) async {
    await _databaseService.createSubscription(subscription);
  }

  @override
  Future<Subscription?> getUserSubscription(String userId) async {
    return await _databaseService.getUserSubscription(userId);
  }

  @override
  Future<void> cancelSubscription(String subscriptionId) async {
    await _databaseService.cancelSubscription(subscriptionId);
  }

  @override
  Stream<Subscription?> listenToUserSubscription(String userId) {
    return _databaseService.listenToUserSubscription(userId);
  }

  @override
  Future<List<Subscription>?> loadAllSubscriptions() async {
    return await _databaseService.loadAllSubscriptions();
  }

  @override
  Future<List<SubscriptionPlan>> getAllSubscriptionPlans() async {
    return await _databaseService.getAllSubscriptionPlans();
  }

  @override
  Future<SubscriptionPlan> updateSubscriptionPlan(SubscriptionPlan plan) async {
    return await _databaseService.updateSubscriptionPlan(plan);
  }
}
