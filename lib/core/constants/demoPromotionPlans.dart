import 'package:myplug_ca/features/promotion/domain/models/promotion_plan.dart';
import 'package:myplug_ca/features/subscription/domain/models/highlight.dart';

List<PromotionPlan> demoPromotionPlans = [
  PromotionPlan(
    id: '1',
    title: 'lite',
    price: 1500.00,
    duration: const Duration(days: 7),
    features: [],
    highlight: Highlight.lite,
  ),
  PromotionPlan(
    id: '1',
    title: 'standard',
    price: 4500.00,
    duration: const Duration(days: 14),
    features: [],
    highlight: Highlight.mostAffordable,
  ),
  PromotionPlan(
    id: '1',
    title: 'pro',
    price: 7500.00,
    duration: const Duration(days: 30),
    features: [],
    highlight: Highlight.recommended,
  ),
  PromotionPlan(
    id: '1',
    title: 'lite',
    price: 1500.00,
    duration: const Duration(days: 90),
    features: [],
    highlight: Highlight.bestValue,
  ),
];
