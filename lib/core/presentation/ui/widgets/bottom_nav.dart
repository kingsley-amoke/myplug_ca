import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/pages/home.dart';
import 'package:myplug_ca/features/chat/presentation/ui/pages/chatpage.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/wallet.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

final List<Widget> _screens = [
  const ChatPage(),
  // Jobs(),
  const Scaffold(),
 const HomePage(),
  const WalletPage(),
  const Scaffold(),
  // Wallet(),
  // Settings(),
];

int _currentIndex = 2;

class _BottomNavState extends State<BottomNav> {
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
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  icon: Icon(
                    Icons.work,
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
