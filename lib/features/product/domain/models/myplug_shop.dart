class MyplugShop {
  final int id;
  final String name;
  final String image;
  final List<String> subshop;

  const MyplugShop({
    required this.id,
    required this.image,
    required this.name,
    required this.subshop,
  });

  factory MyplugShop.fromMap(Map<String, dynamic> map) {
    return MyplugShop(
        id: map['id'],
        image: map['image'],
        name: map['name'],
        subshop: List<String>.from(map['subshop']));
  }

  toMap() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'subshop': subshop,
    };
  }
}
