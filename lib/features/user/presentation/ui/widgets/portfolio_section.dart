import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/section_header.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/domain/models/portfolio.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/portfolio_details.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/add_portfolio.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

Widget portfolioSection(BuildContext context, {required MyplugUser user}) {
  void onAdd() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const AddPortfolioPage()));
  }

  return Consumer<UserProvider>(builder: (context, provider, child) {
    bool isOwner = provider.myplugUser?.id == user.id;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader(
          title: 'Portfolio',
          onAdd: onAdd,
          show: isOwner,
        ),
        const SizedBox(height: 8),
        if (user.portfolios.isEmpty)
          const Text('No portfolio yet.')
        else
          GridView.builder(
            itemCount: isOwner
                ? provider.myplugUser!.portfolios.length
                : user.portfolios.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3 / 2,
            ),
            itemBuilder: (context, index) {
              final portfolio = isOwner
                  ? provider.myplugUser!.portfolios[index]
                  : user.portfolios[index];
              return _portfolioCard(context: context, portfolio: portfolio);
            },
          ),
      ],
    );
  });
}

Widget _portfolioCard(
    {required BuildContext context, required Portfolio portfolio}) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => PortfolioDetailsPage(
                portfolio: portfolio,
              )));
    },
    child: Card(
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          if (portfolio.imageUrls.isNotEmpty)
            Expanded(
              child: Image.network(
                portfolio.imageUrls.first,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              portfolio.title.toSentenceCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}
