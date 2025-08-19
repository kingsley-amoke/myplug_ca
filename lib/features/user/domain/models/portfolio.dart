class Portfolio {
  final String? id;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String? link;

  Portfolio({
    required this.title,
    required this.description,
    required this.imageUrls,
    this.link,
    this.id,
  });

  factory Portfolio.fromMap(Map<String, dynamic> map) => Portfolio(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        imageUrls: List<String>.from(map['imageUrls']),
        link: map['link'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'imageUrls': imageUrls,
        'link': link,
      };

  Portfolio copyWith({
    String? id,
    String? title,
    String? description,
    String? link,
    List<String>? imageUrls,
  }) {
    return Portfolio(
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      link: link ?? this.link,
      id: id ?? this.id,
    );
  }
}
