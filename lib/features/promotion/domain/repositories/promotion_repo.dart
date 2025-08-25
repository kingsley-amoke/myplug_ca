import 'package:fixnbuy/features/promotion/domain/models/promotion.dart';
import 'package:fixnbuy/features/promotion/domain/models/promotion_plan.dart';

abstract class PromotionRepository {
  Future<void> createPromotion(Promotion promotion);
  Future<Promotion?> getProductPromotion(String productId);
  Future<List<Promotion>?> loadAllPromotions();
  Future<void> cancelPromotion(String promotionId);
  Future<List<PromotionPlan>> getAllPromotionPlans();
  Future<PromotionPlan> updatePromotionPlan(PromotionPlan plan);

  bool isExpired(Promotion promotion);
  bool isExpiringSoon(Promotion promotion);
  int daysLeft(Promotion promotion);
}
