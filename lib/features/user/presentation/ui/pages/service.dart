import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/nigerian_states.dart';
import 'package:myplug_ca/core/domain/models/toast.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/modular_search_filter_bar.dart';
import 'package:myplug_ca/features/chat/presentation/ui/pages/messagepage.dart';
import 'package:myplug_ca/features/chat/presentation/viewmodels/chat_provider.dart';
import 'package:myplug_ca/features/subscription/presentation/ui/pages/subscription_page.dart';
import 'package:myplug_ca/features/user/domain/models/skill.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/profile.dart';
import 'package:myplug_ca/features/user/presentation/ui/widgets/user_card.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class Service extends StatefulWidget {
  const Service({super.key, required this.service});

  final Skill service;

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  @override
  void initState() {
    context.read<UserProvider>().getUsersByService(widget.service);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: widget.service.name),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ModularSearchFilterBar(
              onSearch: (searchTerm, filters) {
                context.read<UserProvider>().getUsersByService(widget.service);
                context.read<UserProvider>().filterByParams(
                    location: filters['location'], search: searchTerm);
              },
              locations: nigerianStates,
              showSalary: false,
            ),
            Consumer<UserProvider>(
              builder:
                  (BuildContext context, UserProvider provider, Widget? child) {
                if (provider.usersByServiceLoading) {
                  return Column(
                    children: [
                      SizedBox(
                        height: getScreenHeight(context) / 3,
                      ),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  );
                }
                final navigator = Navigator.of(context);
                if (provider.usersByService.isEmpty) {
                  return Column(
                    children: [
                      SizedBox(
                        height: getScreenHeight(context) / 3,
                      ),
                      const Center(
                        child: Text('No user for now'),
                      ),
                    ],
                  );
                } else {
                  return Flexible(
                    child: ListView.builder(
                      itemCount: provider.usersByService.length,
                      shrinkWrap: false,
                      primary: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = provider.usersByService[index];
                        return UserCard(
                          user: item,
                          onBook: () {
                            if (provider.myplugUser != null) {
                              if (provider.myplugUser!.isSubscribed) {
                                context
                                    .read<ChatProvider>()
                                    .createOrGetConversation(
                                        provider.myplugUser!.id!, item.id!)
                                    .then((conversationId) {
                                  navigator.push(
                                    MaterialPageRoute(
                                      builder: (_) => ChatScreen(
                                        otherUser: item,
                                        conversationId: conversationId,
                                      ),
                                    ),
                                  );
                                });
                              } else {
                                showToast(
                                    message: 'Please subscribe to continue',
                                    type: ToastType.error);
                                navigator.push(MaterialPageRoute(
                                    builder: (_) => const SubscriptionPage()));
                              }
                            }
                          },
                          onViewProfile: () {
                            navigator.push(
                              MaterialPageRoute(
                                builder: (_) => ProfilePage(user: item),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
