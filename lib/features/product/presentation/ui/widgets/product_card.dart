import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_product_card/flutter_product_card.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/images.dart';
import 'package:myplug_ca/features/product/domain/models/product.dart';
// import 'package:myplug_ca/presentation/pages/product_details.dart';

class MyProductCard extends StatelessWidget {
  const MyProductCard({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) {
    return ProductCard(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (_) => ProductDetails(product: product)),
        // );
      },
      imageUrl: noUserImage,
      // imageUrl: product.images.isEmpty
      //     ? Image.asset(
      //         noProductImage,
      //         fit: BoxFit.cover,
      //         height: 170,
      //         width: double.infinity,
      //       )
      //     : Image.network(
      //         product.images[0],
      //         fit: BoxFit.cover,
      //         height: 170,
      //         width: double.infinity,
      //       ),
      categoryName: product.shop.name,
      productName: product.title.toSentenceCase(),
      // location: product.location.toSentenceCase(),
      // price: formatPrice(amount: product.price),
      price: 100,
      rating: getAverageRating(ratings: product.ratings),
    );
  }
}
