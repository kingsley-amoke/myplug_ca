import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:myplug/core/config.dart';
import 'package:myplug/domain/models/product.dart';
import 'package:myplug/domain/models/rating.dart';
import 'package:myplug/presentation/widgets/custom_button.dart';
import 'package:myplug/presentation/widgets/my_appbar.dart';
import 'package:star_rating/star_rating.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

final List<String> images = [
  'assets/images/generic/no_user_image.png',
  'assets/images/generic/no_product.png',
  'assets/images/services/bride.png',
  'assets/images/services/cars.png',
  'assets/images/generic/no_user_image.png',
  'assets/images/generic/no_product.png',
];

String currentImage = noProductImage;

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: 'Product Details'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              currentImage,
              fit: BoxFit.fill,
              height: 240,
              width: double.infinity,
            ),

            const Divider(thickness: 0.4),
            images.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      height: 100,

                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        primary: true,

                        itemBuilder: (context, index) {
                          final String item = images[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                currentImage = item;
                              });
                            },
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.asset(item),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return VerticalDivider();
                        },
                        itemCount: images.length,
                      ),
                    ),
                  )
                : Container(),

            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  StarRating(
                    rating: getAverageRating(ratings: widget.product.ratings),
                    length: 5,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.product.title.toSentenceCase(),
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatPrice(amount: widget.product.price),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Row(
                        children: [
                          Text(
                            'Seller: ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            widget.product.seller.fullname.toCapitalCase(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              //implement contact seller
                            },
                            text: 'contact seller'.toUpperCase(),
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    tabs: [
                      Tab(text: 'Description'),

                      Tab(text: 'Reviews'),
                    ],
                  ),
                  SizedBox(
                    height: 500,
                    child: TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.product.description.toSentenceCase(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ListView.builder(
                          itemCount: widget.product.ratings.length,
                          itemBuilder: (context, index) {
                            final Rating item = widget.product.ratings[index];
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 12),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withAlpha(50),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.username.toSentenceCase(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      StarRating(
                                        length: 5,
                                        rating: item.rating,
                                      ),
                                      Text(formatDate(date: item.date)),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    item.comment.toSentenceCase(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
