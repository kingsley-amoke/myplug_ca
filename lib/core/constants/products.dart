import 'package:myplug_ca/features/product/domain/models/product.dart';
import 'package:myplug_ca/features/product/domain/models/rating.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/core/constants/users.dart';
import 'package:myplug_ca/core/constants/shops.dart';

//products
final List<Product> demoProducts = [
  Product(
    description: 'random desc',
    images: [],
    ratings: [
      Rating(
        comment: 'no review',
        rating: 5,
        username: 'smoq',
        date: DateTime.now(),
      ),
      Rating(
        comment: 'no review',
        rating: 5,
        username: 'smoq',
        date: DateTime.now(),
      ),
      Rating(
        comment: 'no review',
        rating: 3,
        username: 'smoq',
        date: DateTime.now(),
      ),
    ],
    seller: demoUsers[0],
    title: 'title',
    location: 'abuja',
    price: 4900.00,
    shop: shops[0],
  ),
  Product(
      description: 'random desc',
      images: [],
      ratings: [],
      seller: demoUsers[0],
      title: 'title',
      location: 'abuja',
      price: 4900.00,
      shop: shops[2]),
];
