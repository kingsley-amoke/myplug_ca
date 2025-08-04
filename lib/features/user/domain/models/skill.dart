class Skill {
  final int id;
  final String name;
  final String image;

  Skill({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Skill.fromMap(Map<String, dynamic> map) => Skill(
        id: map['id'],
        name: map['name'],
        image: map['image'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'image': image,
      };
}
