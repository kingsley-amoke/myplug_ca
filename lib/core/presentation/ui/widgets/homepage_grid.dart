import 'package:flutter/material.dart';
import 'package:fixnbuy/core/config/config.dart';
import 'package:fixnbuy/features/user/presentation/ui/pages/service.dart';
import 'package:fixnbuy/features/product/presentation/ui/pages/shop.dart';

class HomepageGrid extends StatelessWidget {
  final List<dynamic> items;
  final bool isShop;

  const HomepageGrid({
    super.key,
    required this.items,
    this.isShop = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: 140,
      ),
      primary: true,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      itemCount: items.length < 12 ? items.length : 12,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    isShop ? Shop(shop: item) : Service(service: item),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: (getScreenWidth(context) / 7),
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  item.image,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}
