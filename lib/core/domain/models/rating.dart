class Rating {
  final String username;
  final double rating;
  final String comment;
  final DateTime date;

  const Rating({
    required this.comment,
    required this.rating,
    required this.username,
    required this.date,
  });

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
        comment: map['comment'],
        rating: map['rating'],
        username: map['username'],
        date: DateTime.parse(map['date']));
  }

  toMap() {
    return {
      'username': username,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }
}
