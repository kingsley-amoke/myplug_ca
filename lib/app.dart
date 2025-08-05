import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/theme.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/bottom_nav.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Plug',
      theme: myTheme,
      home: const BottomNav(),
    );
  }
}
