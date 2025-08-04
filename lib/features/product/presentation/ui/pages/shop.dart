import 'package:flutter/material.dart';
import 'package:myplug_ca/features/product/domain/models/myplug_shop.dart';
import 'package:myplug_ca/features/product/domain/models/product.dart';
import 'package:myplug_ca/core/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/product/presentation/ui/widgets/product_grid.dart';
// import 'package:myplug/providers/product_provider.dart';
import 'package:provider/provider.dart';

class Shop extends StatefulWidget {
  const Shop({super.key, required this.shop});

  final MyplugShop shop;

  @override
  State<Shop> createState() => _ShopState();
}

List<Product> products = [];

class _ShopState extends State<Shop> {
  @override
  initState() {
    // products = context.read<ProductProvider>().getProductsByCategory(
    // widget.shop.id,
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: widget.shop.name),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ProductGrid(products: products),
      ),
    );
  }
}
