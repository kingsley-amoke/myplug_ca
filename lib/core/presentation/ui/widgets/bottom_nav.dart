import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/pages/home.dart';
import 'package:myplug_ca/core/presentation/ui/pages/settings.dart';
import 'package:myplug_ca/features/chat/presentation/ui/pages/chatpage.dart';
import 'package:myplug_ca/features/chat/presentation/viewmodels/chat_provider.dart';
import 'package:myplug_ca/features/product/presentation/ui/pages/products_page.dart';
import 'package:myplug_ca/features/subscription/presentation/viewmodels/subscription_provider.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/wallet.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

int _currentIndex = 2;
final List<Widget> _screens = [
  const ConversationListScreen(),
  const ProductsPage(),
  const HomePage(),
  const WalletPage(),
  const Settings(),
];

class _BottomNavState extends State<BottomNav> {
  @override
  void initState() {
    final user = context.read<UserProvider>();
    if (user.isLoggedIn) {
      context
          .read<SubscriptionProvider>()
          .loadUserSubscription(user.myplugUser!.id!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentIndex = 2;
          });
        },
        shape: const CircleBorder(),
        backgroundColor: _currentIndex == 2
            ? Theme.of(context).primaryColor
            : Theme.of(context).unselectedWidgetColor,
        child: const Icon(Icons.home, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        height: 60,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  icon: Icon(
                    Icons.message,
                    size: 30,
                    color: _currentIndex == 0
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).unselectedWidgetColor,
                  ),
                ),
                Positioned(
                  right: 2,
                  child:
                      Consumer<ChatProvider>(builder: (context, provider, _) {
                    int unread = provider.totalUnread;

                    return unread > 0
                        ? CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.green,
                            child: Text(
                              unread.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          )
                        : Container();
                  }),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  icon: Icon(
                    Icons.shopping_bag,
                    size: 30,
                    color: _currentIndex == 1
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).unselectedWidgetColor,
                  ),
                ),
                const SizedBox(width: 60),
              ],
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 3;
                });
              },
              icon: Icon(
                Icons.wallet,
                size: 30,
                color: _currentIndex == 3
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).unselectedWidgetColor,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 4;
                });
              },
              icon: Icon(
                Icons.settings,
                size: 30,
                color: _currentIndex == 4
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).unselectedWidgetColor,
              ),
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
    );
  }
}
