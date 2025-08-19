import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/images.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/custom_button.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/product/domain/models/product.dart';
import 'package:myplug_ca/core/domain/models/rating.dart';
import 'package:myplug_ca/features/product/presentation/ui/widgets/review.dart';
import 'package:myplug_ca/features/product/presentation/view_models/product_provider.dart';

import 'package:provider/provider.dart';
import 'package:star_rating/star_rating.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

String currentImage = noProductImage;
bool showContact = false;

class _ProductDetailsState extends State<ProductDetails> {
  void submitReview({
    required Rating review,
  }) {
    setState(() {
      widget.product.ratings.add(review);
    });

    context.read<ProductProvider>().addReview(
          widget.product,
        );
  }

  void _showAddReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ProductRatingDialog(
          submitReview: (rev) => submitReview(review: rev),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: myAppbar(context, title: 'Product Details'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- MAIN IMAGE WITH ELEGANT STYLE ---
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.asset(
                currentImage,
                fit: BoxFit.cover,
                height: 280,
                width: double.infinity,
              ),
            ),

            // --- IMAGE GALLERY ---
            if (widget.product.images.isNotEmpty)
              Container(
                height: 90,
                margin: const EdgeInsets.only(top: 12),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    final String item = widget.product.images[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() => currentImage = item);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: currentImage == item
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(item, width: 70, height: 70),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemCount: widget.product.images.length,
                ),
              ),

            const SizedBox(height: 20),

            // --- PRODUCT TITLE & PRICE ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StarRating(
                    rating: getAverageRating(ratings: widget.product.ratings),
                    length: 5,
                    starSize: 20,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.product.title.toSentenceCase(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatPrice(amount: widget.product.price),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Seller: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            widget.product.seller.fullname,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    onPressed: () {
                      setState(() {
                        showContact = true;
                      });
                    },
                    text: showContact
                        ? widget.product.seller.phone!
                        : 'Contact Seller',
                    color: Colors.green,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- TABS (DESCRIPTION & REVIEWS) ---
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.black,
                    indicatorColor: Colors.black,
                    tabs: [
                      Tab(text: 'Description'),
                      Tab(text: 'Reviews'),
                    ],
                  ),
                  SizedBox(
                    height: 500,
                    child: TabBarView(
                      children: [
                        // --- DESCRIPTION ---
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            widget.product.description.toSentenceCase(),
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ),

                        // --- REVIEWS ---

                        Column(
                          children: [
                            Expanded(
                              child: widget.product.ratings.isNotEmpty
                                  ? ListView.builder(
                                      padding: const EdgeInsets.all(16),
                                      itemCount: widget.product.ratings.length,
                                      itemBuilder: (context, index) {
                                        final Rating item =
                                            widget.product.ratings[index];
                                        return Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 16),
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.grey.withAlpha(10),
                                                spreadRadius: 2,
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    item.username
                                                        .toSentenceCase(),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    formatDate(date: item.date),
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              StarRating(
                                                length: 5,
                                                rating: item.rating,
                                                starSize: 18,
                                                color: Colors.amber,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                item.comment.toSentenceCase(),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : const Center(
                                      child: Text(
                                        "No reviews yet.",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: ElevatedButton.icon(
                                onPressed: () => _showAddReviewDialog(context),
                                icon: const Icon(Icons.rate_review),
                                label: const Text("Add Review"),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 48),
                                ),
                              ),
                            ),
                          ],
                        )
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
