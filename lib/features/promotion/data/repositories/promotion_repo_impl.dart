import 'package:myplug_ca/features/promotion/domain/models/promotion.dart';
import 'package:myplug_ca/features/promotion/domain/models/promotion_plan.dart';
import 'package:myplug_ca/features/promotion/domain/repositories/promotion_database_service.dart';
import 'package:myplug_ca/features/promotion/domain/repositories/promotion_repo.dart';

class PromotionRepoImpl implements PromotionRepository {
  final PromotionDatabaseService _databaseService;

  const PromotionRepoImpl(this._databaseService);

  @override
  Future<void> cancelPromotion(String promotionId) async {
    return await _databaseService.cancelPromotion(promotionId);
  }

  @override
  Future<void> createPromotion(Promotion promotion) async {
    return await _databaseService.createPromotion(promotion);
  }

  @override
  Future<Promotion?> getProductPromotion(String productId) async {
    return await _databaseService.getProductPromotion(productId);
  }

  Stream<Promotion?> listenToProductPromotion(String productId) {
    return _databaseService.listenToProductPromotion(productId);
  }

  @override
  int daysLeft(Promotion promotion) {
    if (promotion.endDate == null) return 999;
    return promotion.endDate!.difference(DateTime.now()).inDays;
  }

  @override
  bool isExpired(Promotion promotion) {
    return promotion.endDate != null &&
        promotion.endDate!.isBefore(DateTime.now());
  }

  @override
  bool isExpiringSoon(Promotion promotion) {
    if (promotion.endDate == null) return false;
    final diff = promotion.endDate!.difference(DateTime.now()).inDays;
    return diff <= 3 && diff > 0;
  }

  @override
  Future<List<Promotion>?> loadAllPromotions() async {
    return await _databaseService.loadAllPromotions();
  }

  @override
  Future<List<PromotionPlan>> getAllPromotionPlans() async {
    return await _databaseService.getAllPromotionPlans();
  }

  @override
  Future<PromotionPlan> updatePromotionPlan(PromotionPlan plan) async {
    return await _databaseService.updatePromotionPlan(plan);
  }
}
