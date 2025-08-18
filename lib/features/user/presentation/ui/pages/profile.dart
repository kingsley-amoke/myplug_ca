// lib/features/user/views/profile_page.dart
import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/images.dart';
import 'package:myplug_ca/core/models/toast.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/subscription/presentation/ui/pages/subscription_page.dart';
import 'package:myplug_ca/features/subscription/presentation/ui/widgets/cancel_sub.dart';
import 'package:myplug_ca/features/subscription/presentation/viewmodels/subscription_provider.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/presentation/ui/widgets/bio_section.dart';
import 'package:myplug_ca/features/user/presentation/ui/widgets/portfolio_section.dart';
import 'package:myplug_ca/features/user/presentation/ui/widgets/skills_section.dart';
import 'package:myplug_ca/features/user/presentation/ui/widgets/testimonial_section.dart';
import 'package:change_case/change_case.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final MyplugUser user;

  const ProfilePage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: 'Professional Profile'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, user: user),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocation(user),
                  const SizedBox(height: 16),
                  skillsSection(user),
                  const SizedBox(height: 16),
                  BioSection(user: user),
                  const SizedBox(height: 24),
                  Consumer<SubscriptionProvider>(builder: (BuildContext context,
                      SubscriptionProvider provider, Widget? child) {
                    if (provider.subscription != null) {
                      return CancelSubscriptionCard(
                          subscription: provider.subscription!,
                          onCancel: () {
                            provider.cancel().then((_) {
                              showToast(context,
                                  message: 'Success', type: ToastType.success);
                            });
                          });
                    } else {
                      return _buildSubscriptionSection(context);
                    }
                  }),
                  const SizedBox(height: 24),
                  portfolioSection(context, user: user),
                  const SizedBox(height: 24),
                  testimonialsSection(context, user: user),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, {required MyplugUser user}) {
    return Column(
      //TODO: change image to network
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: getScreenHeight(context) / 4,
          width: getScreenWidth(context),
          child: Image.asset(user.image ?? noUserImage),
        ),
        const SizedBox(width: 16),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0),
          child: Text(
            user.fullname.toCapitalCase(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildLocation(MyplugUser user) {
    final loc = user.location;
    if (loc == null) return const SizedBox.shrink();

    return Row(
      children: [
        const Icon(Icons.location_on, size: 18, color: Colors.grey),
        const SizedBox(width: 6),
        Text(
          loc.address ?? 'Unknown location',
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

Widget _buildSubscriptionSection(BuildContext context) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    child: ListTile(
      leading: const Icon(Icons.workspace_premium, color: Colors.amber),
      title: const Text(
        "Upgrade Subscription",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: const Text("Unlock premium features & benefits"),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SubscriptionPage(),
          ),
        );
      },
    ),
  );
}
