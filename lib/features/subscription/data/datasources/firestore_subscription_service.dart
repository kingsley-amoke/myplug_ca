import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myplug_ca/features/subscription/domain/models/subscription.dart';
import 'package:myplug_ca/features/subscription/domain/repositories/subscription_repo.dart';

class FirestoreSubscriptionService implements SubscriptionRepository {
  final FirebaseFirestore _firestore;

  FirestoreSubscriptionService(this._firestore);

  final _collection = 'subscriptions';

  @override
  Future<void> createSubscription(Subscription subscription) async {
    final docRef = _firestore.collection(_collection).doc();

    return await docRef.set(subscription.copyWith(id: docRef.id).toMap());
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
    await _firestore.collection(_collection).doc(subscriptionId).delete();
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

  @override
  Future<List<Subscription>?> loadAllSubscriptions() async {
    List<Subscription> subscriptions = [];
    final snapshot = await _firestore.collection(_collection).get();

    if (snapshot.docs.isEmpty) return null;
    final docs = snapshot.docs;

    for (final doc in docs) {
      subscriptions.add(Subscription.fromMap({...doc.data(), 'id': doc.id}));
    }

    return subscriptions;
  }
}
