import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myplug_ca/features/subscription/domain/models/subscription.dart';
import 'package:myplug_ca/features/subscription/domain/repositories/subscription_repo.dart';

class FirestoreSubscriptionService implements SubscriptionRepository {
  final FirebaseFirestore _firestore;

  FirestoreSubscriptionService(this._firestore);

  final _collection = 'subscriptions';

  @override
  Future<void> createSubscription(Subscription subscription) async {
    await _firestore
        .collection(_collection)
        .doc(subscription.id)
        .set(subscription.toMap());
  }

  @override
  Future<Subscription?> getUserSubscription(String userId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    final data = snapshot.docs.first.data();
    return Subscription.fromMap({...data, 'id': snapshot.docs.first.id});
  }

  @override
  Future<void> cancelSubscription(String subscriptionId) async {
    await _firestore.collection(_collection).doc(subscriptionId).update({
      'isActive': false,
      'endDate': DateTime.now().toIso8601String(),
    });
  }

  @override
  Stream<Subscription?> listenToUserSubscription(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      final doc = snapshot.docs.first;
      return Subscription.fromMap({...doc.data(), 'id': doc.id});
    });
  }
}
