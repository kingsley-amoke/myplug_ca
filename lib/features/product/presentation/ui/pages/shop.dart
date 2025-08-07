import 'package:flutter/material.dart';
import 'package:myplug_ca/core/constants/nigerian_states.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/modular_search_filter_bar.dart';
import 'package:myplug_ca/features/product/domain/models/myplug_shop.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/product/presentation/ui/widgets/product_grid.dart';
import 'package:myplug_ca/features/product/presentation/view_models/product_provider.dart';
import 'package:provider/provider.dart';

class Shop extends StatefulWidget {
  const Shop({super.key, required this.shop});

  final MyplugShop shop;

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  initState() {
    context.read<ProductProvider>().getProductsByCategory(widget.shop);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: widget.shop.name),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ModularSearchFilterBar(
                onSearch: (serchTerm, filters) {
                  context
                      .read<ProductProvider>()
                      .getProductsByCategory(widget.shop);
                  context.read<ProductProvider>().filterByParams(
                        location: filters['location'],
                        rating: filters['rating'],
                        minPrice: filters['price'],
                      );
                },
                locations: nigerianStates,
                showRating: true,
                showPrice: true,
                showSalary: false,
              ),
              Consumer<ProductProvider>(
                builder: (context, provider, child) {
                  return ProductGrid(products: provider.productsByCategory);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
