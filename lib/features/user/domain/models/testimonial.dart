class Testimonial {
  final String authorId;
  final String content;
  final double rating;

  Testimonial({
    required this.authorId,
    required this.content,
    required this.rating,
  });

  factory Testimonial.fromMap(Map<String, dynamic> map) => Testimonial(
        authorId: map['author_id'],
        content: map['content'],
        rating: (map['rating'] as num).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'author_id': authorId,
        'content': content,
        'rating': rating,
      };
}
