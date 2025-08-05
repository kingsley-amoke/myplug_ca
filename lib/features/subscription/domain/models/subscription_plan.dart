class SubscriptionPlan {
  final String id;
  final String title;
  final String description;
  final double price;
  final Duration duration;

  SubscriptionPlan({
    required this.id,
    required this.title,
    required this.price,
    required this.duration,
    required this.description,
  });

  factory SubscriptionPlan.fromMap(Map<String, dynamic> map) =>
      SubscriptionPlan(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        price: (map['price'] as num).toDouble(),
        duration: Duration(days: map['durationDays']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'durationDays': duration.inDays,
      };

  SubscriptionPlan copyWith({
    String? title,
    double? price,
    String? description,
    Duration? duration,
  }) {
    return SubscriptionPlan(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      duration: duration ?? this.duration,
    );
  }
}
