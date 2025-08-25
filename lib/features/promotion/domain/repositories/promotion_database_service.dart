import 'package:fixnbuy/features/promotion/domain/models/promotion.dart';
import 'package:fixnbuy/features/promotion/domain/models/promotion_plan.dart';

abstract class PromotionDatabaseService {
  Future<void> createPromotion(Promotion promotion);
  Future<Promotion?> getProductPromotion(String productId);
  Future<List<Promotion>?> loadAllPromotions();
  Future<void> cancelPromotion(String promotionId);
  Stream<Promotion?> listenToProductPromotion(String productId);
  Future<List<PromotionPlan>> getAllPromotionPlans();
  Future<PromotionPlan> updatePromotionPlan(PromotionPlan plan);
}
