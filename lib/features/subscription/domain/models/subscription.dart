import 'package:myplug_ca/features/subscription/domain/models/subscription_plan.dart';

class Subscription {
  final String id;
  final String userId;
  final SubscriptionPlan plan;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;

  Subscription({
    required this.id,
    required this.userId,
    required this.plan,
    required this.startDate,
    this.endDate,
    this.isActive = true,
  });

  factory Subscription.fromMap(Map<String, dynamic> map) => Subscription(
        id: map['id'],
        userId: map['userId'],
        plan: SubscriptionPlan.fromMap(map['plan']),
        startDate: DateTime.parse(map['startDate']),
        endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
        isActive: map['isActive'] ?? true,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'plan': plan.toMap(),
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'isActive': isActive,
      };

  Subscription copyWith({
    SubscriptionPlan? plan,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) {
    return Subscription(
      id: id,
      userId: userId,
      plan: plan ?? this.plan,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
    );
  }
}
