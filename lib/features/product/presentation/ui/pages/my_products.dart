import 'package:flutter/material.dart';
import 'package:fixnbuy/core/presentation/ui/widgets/modular_search_filter_bar.dart';
import 'package:fixnbuy/core/presentation/ui/widgets/my_appbar.dart';
import 'package:fixnbuy/features/admin/presentation/ui/widgets/product_card.dart';
import 'package:fixnbuy/features/product/domain/models/product.dart';
import 'package:fixnbuy/features/product/presentation/ui/pages/add_product.dart';
import 'package:fixnbuy/features/product/presentation/view_models/product_provider.dart';
import 'package:fixnbuy/features/user/domain/models/myplug_user.dart';
import 'package:fixnbuy/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class MyProductsPage extends StatefulWidget {
  const MyProductsPage({super.key});

  @override
  State<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  @override
  void initState() {
    super.initState();

    MyplugUser? user = context.read<UserProvider>().myplugUser;

    context.read<ProductProvider>().getMyProducts(user!.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: 'My products'),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          return provider.myProducts.isEmpty
              ? const Center(child: Text("No products available"))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ModularSearchFilterBar(
                          showFilterIcon: false,
                          onSearch: (search, _) {
                            provider.searchMyProducts(search: search);
                          }),
                    ),
                    Flexible(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: provider.filteredMyProducts.length,
                        itemBuilder: (context, index) {
                          Product product = provider.filteredMyProducts[index];
                          return ProductCard(product: product);
                        },
                      ),
                    ),
                  ],
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductPage()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2,
        child: const Icon(
          Icons.add_rounded,
          size: 28,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
