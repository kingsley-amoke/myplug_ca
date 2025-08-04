class Portfolio {
  final String title;
  final String description;
  final List<String> imageUrls;
  final String? link;

  Portfolio({
    required this.title,
    required this.description,
    required this.imageUrls,
    this.link,
  });

  factory Portfolio.fromMap(Map<String, dynamic> map) => Portfolio(
        title: map['title'],
        description: map['description'],
        imageUrls: List<String>.from(map['imageUrls']),
        link: map['link'],
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'imageUrls': imageUrls,
        'link': link,
      };
}

