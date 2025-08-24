import 'package:flutter/foundation.dart';
import 'package:myplug_ca/features/subscription/data/repositories/subscription_repo_impl.dart';
import 'package:myplug_ca/features/subscription/domain/models/subscription.dart';
import 'package:myplug_ca/features/subscription/domain/models/subscription_plan.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionRepoImpl _subscriptionRepoImpl;

  SubscriptionProvider(this._subscriptionRepoImpl);

  Subscription? _subscription;
  List<Subscription> allSubscriptions = [];
  List<Subscription> filteredSubscriptions = [];
  Subscription? get subscription => _subscription;

  List<SubscriptionPlan> plans = [];

  bool get isExpired =>
      _subscription != null && _subscriptionRepoImpl.isExpired(_subscription!);
  bool get isExpiringSoon =>
      _subscription != null &&
      _subscriptionRepoImpl.isExpiringSoon(_subscription!);
  int get daysLeft => _subscription != null
      ? _subscriptionRepoImpl.daysLeft(_subscription!)
      : 999;

  Future<void> loadAllPlans() async {
    plans = await _subscriptionRepoImpl.getAllSubscriptionPlans();
    sortPlans();
  }

  Future<void> updatePlan(
      {required SubscriptionPlan plan, required double price}) async {
    final updatedPlan = plan.copyWith(price: price);

    await _subscriptionRepoImpl.updateSubscriptionPlan(updatedPlan);
    final index = plans.indexOf(plan);
    plans.remove(plan);
    plans.insert(index, updatedPlan);
    sortPlans();
  }

  void sortPlans() {
    plans.sort((a, b) => a.price.compareTo(b.price));
    notifyListeners();
  }

  Future<void> loadUserSubscription(String userId) async {
    _subscription = await _subscriptionRepoImpl.getUserSubscription(userId);
    checkAndCancelSubscription();
    notifyListeners();
  }

  Future<void> loadAllSubscriptions() async {
    loadAllPlans();
    final subs = await _subscriptionRepoImpl.loadAllSubscriptions();
    if (subs != null && subs.isNotEmpty) {
      allSubscriptions = subs;
      filteredSubscriptions = subs;
      notifyListeners();
    }
  }

  Future<void> create(Subscription subscription) async {
    await _subscriptionRepoImpl.createSubscription(subscription);
    _subscription = subscription;
    allSubscriptions.insert(0, subscription);
    filteredSubscriptions.insert(0, subscription);
    notifyListeners();
  }

  Future<void> cancel() async {
    if (_subscription != null) {
      await _subscriptionRepoImpl.cancelSubscription(_subscription!.id!);
      _subscription =
          _subscription!.copyWith(isActive: false, endDate: DateTime.now());
      _subscription = null;
      notifyListeners();
    }
  }

  Future<void> cancelUserSubscription(Subscription sub) async {
    await _subscriptionRepoImpl.cancelSubscription(sub.id!);
    allSubscriptions.remove(sub);
    notifyListeners();
  }

  void listenToSubscription(String userId) {
    _subscriptionRepoImpl.listenToUserSubscription(userId).listen((sub) {
      _subscription = sub;
      notifyListeners();
    });
  }

  void checkAndCancelSubscription() {
    if (subscription?.endDate != null &&
        DateTime.now().isAfter(subscription!.endDate!)) {
      cancel();
    }
  }

  List<Subscription> searchAllSubscriptions({
    required String search,
    required List<MyplugUser> allUsers,
  }) {
    // If search is empty, restore all users
    if (search.trim().isEmpty) {
      filteredSubscriptions = List<Subscription>.from(allSubscriptions);
      notifyListeners();
      return filteredSubscriptions;
    }

    List<Subscription> matches = [];

    for (Subscription sub in allSubscriptions) {
      final term = search.toLowerCase();
      final username =
          allUsers.firstWhere((u) => u.id == sub.userId).fullname.toLowerCase();

      if (username.contains(term)) {
        matches.add(sub);
      }
    }

    filteredSubscriptions = matches;
    notifyListeners();
    return filteredSubscriptions;
  }
}
