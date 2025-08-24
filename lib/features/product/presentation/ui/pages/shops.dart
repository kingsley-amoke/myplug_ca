import 'package:flutter/material.dart';
import 'package:myplug_ca/core/constants/shops.dart';
import 'package:myplug_ca/features/product/presentation/ui/pages/shop.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';

class Shops extends StatelessWidget {
  const Shops({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: 'All Shops'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: ((context, index) {
                final shop = shops[index];
                return ListTile(
                  title: Text(shop.name,
                      style: const TextStyle(color: Colors.black)),
                  leading: CircleAvatar(child: Image.asset(shop.image)),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => Shop(shop: shop)),
                    );
                  },
                );
              }),
              separatorBuilder: (context, index) {
                return const Divider(indent: 15);
              },
              itemCount: shops.length,
            ),
          ],
        ),
      ),
    );
  }
}
