import 'package:myplug_ca/features/promotion/domain/models/promotion_plan.dart';

class Promotion {
  final String? id;
  final String productId;
  final PromotionPlan plan;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;

  Promotion({
    this.id,
    required this.productId,
    required this.plan,
    required this.startDate,
    this.endDate,
    this.isActive = true,
  });

  factory Promotion.fromMap(Map<String, dynamic> map) => Promotion(
        id: map['id'],
        productId: map['productId'],
        plan: PromotionPlan.fromMap(map['plan']),
        startDate: DateTime.parse(map['startDate']),
        endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
        isActive: map['isActive'] ?? true,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'productId': productId,
        'plan': plan.toMap(),
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'isActive': isActive,
      };

  Promotion copyWith({
    PromotionPlan? plan,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? id,
  }) {
    return Promotion(
      id: id ?? this.id,
      productId: productId,
      plan: plan ?? this.plan,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
    );
  }
}
