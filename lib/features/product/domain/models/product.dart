import 'package:myplug_ca/features/product/domain/models/myplug_shop.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/core/domain/models/rating.dart';

class Product {
  final String? id;
  final String title;
  final String description;
  final List<String> images;
  final MyplugUser seller;
  final List<Rating> ratings;
  final String location;
  final double price;
  final MyplugShop shop;
  final bool isPromoted;

  Product({
    this.id,
    required this.description,
    required this.images,
    this.ratings = const [],
    required this.seller,
    required this.title,
    required this.location,
    required this.price,
    this.isPromoted = false,
    required this.shop,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      description: map['description'],
      images: List<String>.from(map['images']),
      ratings: (map['ratings'] as List? ?? [])
          .map((e) => Rating.fromMap(e))
          .toList(),
      seller: MyplugUser.fromMap(map['seller']),
      title: map['title'],
      location: map['location'],
      isPromoted: map['is_promoted'],
      price: map['price'],
      shop: MyplugShop.fromMap(
        map['shop'],
      ),
    );
  }

  toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'images': images,
      'price': price,
      'location': location,
      'is_promoted': isPromoted,
      'shop': shop.toMap(),
      'seller': seller.toMap(),
      'ratings': ratings.map((e) => e.toMap()).toList(),
    };
  }

  Product copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    double? price,
    bool? isPromoted,
    Rating? rating,
    List<String>? images,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      price: price ?? this.price,
      isPromoted: isPromoted ?? this.isPromoted,
      shop: shop,
      seller: seller,
      ratings: rating != null ? [...ratings, rating] : ratings,
      images: images ?? this.images,
    );
  }
}
