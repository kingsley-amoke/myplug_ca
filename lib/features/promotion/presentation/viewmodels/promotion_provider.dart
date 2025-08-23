import 'package:flutter/foundation.dart';
import 'package:myplug_ca/features/promotion/data/repositories/promotion_repo_impl.dart';
import 'package:myplug_ca/features/promotion/domain/models/promotion.dart';

class PromotionProvider extends ChangeNotifier {
  final PromotionRepoImpl _promotionRepoImpl;

  PromotionProvider(this._promotionRepoImpl);

  Promotion? _promotion;
  Promotion? get promotion => _promotion;

  bool get isExpired =>
      _promotion != null && _promotionRepoImpl.isExpired(_promotion!);
  bool get isExpiringSoon =>
      _promotion != null && _promotionRepoImpl.isExpiringSoon(_promotion!);
  int get daysLeft =>
      _promotion != null ? _promotionRepoImpl.daysLeft(_promotion!) : 999;

  Future<void> loadProductPromotion(String productId) async {
    _promotion = await _promotionRepoImpl.getProductPromotion(productId);
    // checkAndCancelPromotion();
    notifyListeners();
  }

  Future<void> create(Promotion promotion) async {
    await _promotionRepoImpl.createPromotion(promotion);
    _promotion = promotion;
    notifyListeners();
  }

  Future<void> deletePromotion(String productId) async {
    final promotion = await _promotionRepoImpl.getProductPromotion(productId);

    _promotionRepoImpl.cancelPromotion(promotion!.id!);
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

  // void checkAndCancelPromotion() {
  //   if (promotion?.endDate != null &&
  //       DateTime.now().isAfter(promotion!.endDate!)) {
  //     cancel();
  //   }
  // }
}
