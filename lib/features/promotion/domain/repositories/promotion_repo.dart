import 'package:myplug_ca/features/promotion/domain/models/promotion.dart';

abstract class PromotionRepository {
  Future<void> createPromotion(Promotion promotion);
  Future<Promotion?> getProductPromotion(String productId);
  Future<List<Promotion>?> loadAllPromotions();
  Future<void> cancelPromotion(String promotionId);

  bool isExpired(Promotion promotion);
  bool isExpiringSoon(Promotion promotion);
  int daysLeft(Promotion promotion);
}
