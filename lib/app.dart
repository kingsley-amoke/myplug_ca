import 'package:flutter/material.dart';
import 'package:myplug_ca/core/ui/pages/home.dart';
import 'package:myplug_ca/core/config/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Plug',
      theme: myTheme,
      home: const HomePage(),
    );
  }
}
