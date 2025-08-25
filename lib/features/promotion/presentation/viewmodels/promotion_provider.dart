import 'package:flutter/foundation.dart';
import 'package:fixnbuy/features/promotion/data/repositories/promotion_repo_impl.dart';
import 'package:fixnbuy/features/promotion/domain/models/promotion.dart';
import 'package:fixnbuy/features/promotion/domain/models/promotion_plan.dart';

class PromotionProvider extends ChangeNotifier {
  final PromotionRepoImpl _promotionRepoImpl;

  PromotionProvider(this._promotionRepoImpl);

  Promotion? _promotion;
  Promotion? get promotion => _promotion;

  List<PromotionPlan> plans = [];

  bool get isExpired =>
      _promotion != null && _promotionRepoImpl.isExpired(_promotion!);
  bool get isExpiringSoon =>
      _promotion != null && _promotionRepoImpl.isExpiringSoon(_promotion!);
  int get daysLeft =>
      _promotion != null ? _promotionRepoImpl.daysLeft(_promotion!) : 999;

  Future<void> loadAllPlans() async {
    plans = await _promotionRepoImpl.getAllPromotionPlans();
    sortPlans();
    notifyListeners();
  }

  Future<void> updatePlan(
      {required PromotionPlan plan, required double price}) async {
    final updatedPlan = plan.copyWith(price: price);

    await _promotionRepoImpl.updatePromotionPlan(updatedPlan);
    final index = plans.indexOf(plan);
    plans.remove(plan);
    plans.insert(index, updatedPlan);
    sortPlans();
  }

  void sortPlans() {
    plans.sort((a, b) => a.price.compareTo(b.price));
    notifyListeners();
  }

  Future<void> loadProductPromotion(String productId) async {
    _promotion = await _promotionRepoImpl.getProductPromotion(productId);
    // checkAndCancelPromotion();
    notifyListeners();
  }

  Future<void> create(Promotion promotion) async {
    await _promotionRepoImpl.createPromotion(promotion);
    _promotionRepoImpl.cancelPromotion(promotion.id!);

    _promotion = promotion;
    notifyListeners();
  }

  Future<void> deletePromotion(String productId) async {
    final promotion = await _promotionRepoImpl.getProductPromotion(productId);
    if (promotion != null) {
      _promotionRepoImpl.cancelPromotion(promotion.id!);
    }
  }

  Future<void> cancel() async {
    if (_promotion != null) {
      await _promotionRepoImpl.cancelPromotion(_promotion!.id!);
      _promotion =
          _promotion!.copyWith(isActive: false, endDate: DateTime.now());
      _promotion = null;
      notifyListeners();
    }
  }

  void listenToPromotion(String productId) {
    _promotionRepoImpl.listenToProductPromotion(productId).listen((sub) {
      _promotion = sub;
      notifyListeners();
    });
  }

  Future<List<String>> checkAndCancelPromotions() async {
    List<String> productIds = [];
    final promotions = await _promotionRepoImpl.loadAllPromotions();

    if (promotions == null || promotions.isEmpty) return productIds;

    for (Promotion promo in promotions) {
      if (promo.endDate != null && DateTime.now().isAfter(promo.endDate!)) {
        productIds.add(promo.productId);
        _promotionRepoImpl.cancelPromotion(promo.id!);
      }
    }

    return productIds;
  }
}
