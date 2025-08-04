import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/service.dart';
import 'package:myplug_ca/features/product/presentation/ui/pages/shop.dart';

class HomepageGrid extends StatelessWidget {
  HomepageGrid({super.key, required this.items, this.isShop = false});

  bool isShop;
  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: 120,
      ),
      primary: true,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      itemCount: items.length < 12 ? items.length : items.sublist(0, 12).length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    isShop ? Shop(shop: item) : Service(service: item),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  item.image,
                  width: (getScreenWidth(context) / 8),
                  height: 50,
                ),
                Text(
                  item.name,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
