import 'package:flutter/material.dart';
import 'package:myplug_ca/core/constants/nigerian_states.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/modular_search_filter_bar.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/product/presentation/ui/widgets/product_grid.dart';
import 'package:myplug_ca/features/product/presentation/view_models/product_provider.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: 'Products', implyLeading: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ModularSearchFilterBar(
              onSearch: (search, filter) {
                final location = filter['location'];
                final rating = filter['rating'];
                final price = filter['price'];

                context.read<ProductProvider>().filterAllProductsByParams(
                      location: location,
                      searchTerm: search,
                      rating: rating,
                      minPrice: price,
                    );
              },
              locations: nigerianStates,
              showSalary: false,
              showRating: true,
              showPrice: true,
            ),
            Consumer<ProductProvider>(builder: (context, provider, _) {
              print(provider.products.length);
              return ProductGrid(products: provider.allProducts);
            }),
          ],
        ),
      ),
    );
  }
}
