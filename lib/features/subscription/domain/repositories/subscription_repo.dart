import 'package:myplug_ca/features/subscription/domain/models/subscription.dart';

abstract class SubscriptionRepository {
  Future<void> createSubscription(Subscription subscription);
  Future<Subscription?> getUserSubscription(String userId);
  Future<List<Subscription>?> loadAllSubscriptions();
  Future<void> cancelSubscription(String subscriptionId);
  Stream<Subscription?> listenToUserSubscription(String userId);
}
