import 'package:flutter/material.dart';

import 'package:myplug_ca/core/constants/shops.dart';
import 'package:myplug_ca/core/constants/skills.dart';
import 'package:myplug_ca/features/product/presentation/view_models/product_provider.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/services.dart';
import 'package:myplug_ca/features/product/presentation/ui/pages/shops.dart';

import 'package:myplug_ca/core/ui/widgets/home_search.dart';
import 'package:myplug_ca/core/ui/widgets/homepage_grid.dart';
import 'package:myplug_ca/features/product/presentation/ui/widgets/product_grid.dart';
// import 'package:myplug_ca/providers/product_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final TextEditingController _searchController = TextEditingController();

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeSearch(searchController: _searchController),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 8.0,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Services'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const Services()),
                          );
                        },
                        child: Text('See all'),
                      ),
                    ],
                  ),
                  HomepageGrid(items: services),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Shops'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const Shops()),
                          );
                        },
                        child: Text('See all'),
                      ),
                    ],
                  ),
                  HomepageGrid(items: shops, isShop: true),
                  const SizedBox(height: 10),
                  Consumer<ProductProvider>(builder: (context, provider, _) {
                    return ProductGrid(products: provider.products);
                  }),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
