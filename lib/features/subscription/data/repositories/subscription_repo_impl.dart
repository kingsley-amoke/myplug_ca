import 'package:myplug_ca/features/subscription/domain/repositories/subscription_repo.dart';
import 'package:myplug_ca/features/subscription/domain/models/subscription.dart';
import 'package:myplug_ca/features/subscription/services/database_service.dart';

class SubscriptionRepoImpl extends SubscriptionRepository {
  final SubscriptionDatabaseService _databaseService;

  SubscriptionRepoImpl(this._databaseService);

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

  bool isExpired(Subscription sub) {
    return sub.endDate != null && sub.endDate!.isBefore(DateTime.now());
  }

  bool isExpiringSoon(Subscription sub) {
    if (sub.endDate == null) return false;
    final diff = sub.endDate!.difference(DateTime.now()).inDays;
    return diff <= 3 && diff > 0;
  }

  int daysLeft(Subscription sub) {
    if (sub.endDate == null) return 999;
    return sub.endDate!.difference(DateTime.now()).inDays;
  }
}
