import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myplug_ca/features/promotion/domain/models/promotion.dart';
import 'package:myplug_ca/features/promotion/domain/models/promotion_plan.dart';
import 'package:myplug_ca/features/promotion/domain/repositories/promotion_database_service.dart';

class PromotionFirestore implements PromotionDatabaseService {
  final FirebaseFirestore _firestore;

  PromotionFirestore(this._firestore);

  final _collection = 'promotions';

  @override
  Future<void> createPromotion(Promotion promotion) async {
    final docRef = _firestore.collection(_collection).doc();

    return await docRef.set(promotion.copyWith(id: docRef.id).toMap());
  }

  @override
  Future<Promotion?> getProductPromotion(String productId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('productId', isEqualTo: productId)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    final data = snapshot.docs.first.data();
    return Promotion.fromMap({...data, 'id': snapshot.docs.first.id});
  }

  @override
  Future<void> cancelPromotion(String promotionId) async {
    await _firestore.collection(_collection).doc(promotionId).delete();
  }

  @override
  Stream<Promotion?> listenToProductPromotion(String productId) {
    return _firestore
        .collection(_collection)
        .where('productId', isEqualTo: productId)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      final doc = snapshot.docs.first;
      return Promotion.fromMap({...doc.data(), 'id': doc.id});
    });
  }

  @override
  Future<List<Promotion>?> loadAllPromotions() async {
    List<Promotion> promotions = [];
    final snapshot = await _firestore.collection(_collection).get();

    if (snapshot.docs.isEmpty) return null;
    final docs = snapshot.docs;

    for (final doc in docs) {
      promotions.add(Promotion.fromMap({...doc.data(), 'id': doc.id}));
    }

    return promotions;
  }

  @override
  Future<List<PromotionPlan>> getAllPromotionPlans() async {
    List<PromotionPlan> promotionPlans = [];
    final snapshot = await _firestore.collection('promotionplans').get();

    if (snapshot.docs.isEmpty) return [];
    final docs = snapshot.docs;

    for (final doc in docs) {
      promotionPlans.add(PromotionPlan.fromMap({...doc.data(), 'id': doc.id}));
    }

    return promotionPlans;
  }

  @override
  Future<PromotionPlan> updatePromotionPlan(PromotionPlan plan) async {
    await _firestore
        .collection('promotionplans')
        .doc(plan.id)
        .update(plan.toMap());
    return plan;
  }
}
