import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/theme.dart';
import 'package:myplug_ca/core/presentation/ui/pages/auth.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/signin.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'login': (_) => const LoginPage()},
      title: 'My Plug',
      theme: myTheme,
      themeMode: ThemeMode.system,
      home: const Auth(),
    );
  }
}
