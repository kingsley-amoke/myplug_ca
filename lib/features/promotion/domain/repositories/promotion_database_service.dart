import 'package:myplug_ca/features/promotion/domain/models/promotion.dart';

abstract class PromotionDatabaseService {
  Future<void> createPromotion(Promotion promotion);
  Future<Promotion?> getProductPromotion(String productId);
  Future<List<Promotion>?> loadAllPromotions();
  Future<void> cancelPromotion(String promotionId);
  Stream<Promotion?> listenToProductPromotion(String productId);
}
