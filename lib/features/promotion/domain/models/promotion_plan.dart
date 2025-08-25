import 'package:fixnbuy/features/subscription/domain/models/highlight.dart';

class PromotionPlan {
  final String? id;
  final String title;
  final List<String> features;
  final double price;
  final Duration duration;
  final Highlight highlight;

  PromotionPlan(
      {this.id,
      required this.title,
      required this.price,
      required this.duration,
      required this.features,
      required this.highlight});

  factory PromotionPlan.fromMap(Map<String, dynamic> map) => PromotionPlan(
        id: map['id'],
        title: map['title'],
        features: List<String>.from(map['features']),
        price: (map['price'] as num).toDouble(),
        duration: Duration(
          days: map['durationDays'],
        ),
        highlight: SubHighlight.fromString(map['highlight']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'features': features,
        'price': price,
        'durationDays': duration.inDays,
        'highlight': highlight.value
      };

  PromotionPlan copyWith({
    String? id,
    String? title,
    double? price,
    List<String>? features,
    Duration? duration,
    Highlight? highlight,
  }) {
    return PromotionPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      features: features ?? this.features,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      highlight: highlight ?? this.highlight,
    );
  }
}
