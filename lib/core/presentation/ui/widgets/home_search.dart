import 'package:flutter/material.dart';
import 'package:myplug_ca/core/constants/images.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_input.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/profile.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class HomeSearch extends StatelessWidget {
  const HomeSearch({super.key, required this.searchController});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      height: 240,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius:
            const BorderRadius.only(bottomRight: Radius.circular(120)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Consumer<UserProvider>(
            builder:
                (BuildContext context, UserProvider provider, Widget? child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, ${provider.myplugUser?.lastName ?? 'Anonymous'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Lagos',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      provider.myplugUser != null
                          ? Navigator.of(
                              context,
                            ).push(
                              MaterialPageRoute(
                                builder: (_) => ProfilePage(
                                  user: provider.myplugUser!,
                                
                                ),
                              ),
                            )
                          : null;
                    },
                    child: CircleAvatar(
                      child: Image.asset(
                          provider.myplugUser?.image ?? noUserImage),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: MyInput(
                  controller: searchController,
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'What can we do for you today?',
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
        ],
      ),
    );
  }
}
