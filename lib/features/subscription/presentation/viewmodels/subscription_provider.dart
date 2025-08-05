import 'package:flutter/foundation.dart';
import 'package:myplug_ca/features/subscription/data/repositories/subscription_repo_impl.dart';
import 'package:myplug_ca/features/subscription/domain/models/subscription.dart';

class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionRepoImpl _subscriptionRepoImpl;

  SubscriptionProvider(this._subscriptionRepoImpl);

  Subscription? _subscription;
  Subscription? get subscription => _subscription;

  bool get isExpired =>
      _subscription != null && _subscriptionRepoImpl.isExpired(_subscription!);
  bool get isExpiringSoon =>
      _subscription != null &&
      _subscriptionRepoImpl.isExpiringSoon(_subscription!);
  int get daysLeft => _subscription != null
      ? _subscriptionRepoImpl.daysLeft(_subscription!)
      : 999;

  Future<void> loadUserSubscription(String userId) async {
    _subscription = await _subscriptionRepoImpl.getUserSubscription(userId);
    notifyListeners();
  }

  Future<void> create(Subscription subscription) async {
    await _subscriptionRepoImpl.createSubscription(subscription);
    _subscription = subscription;
    notifyListeners();
  }

  Future<void> cancel() async {
    if (_subscription != null) {
      await _subscriptionRepoImpl.cancelSubscription(_subscription!.id);
      _subscription =
          _subscription!.copyWith(isActive: false, endDate: DateTime.now());
      notifyListeners();
    }
  }

  void listenToSubscription(String userId) {
    _subscriptionRepoImpl.listenToUserSubscription(userId).listen((sub) {
      _subscription = sub;
      notifyListeners();
    });
  }
}
