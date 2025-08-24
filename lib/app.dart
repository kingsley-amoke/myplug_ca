import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/theme.dart';
import 'package:myplug_ca/core/presentation/ui/pages/auth.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/bottom_nav.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/signin.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/signup.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        'home': (_) => const BottomNav(),
        'login': (_) => const LoginPage(),
        'register': (_) => const SignupPage(),
      },
      title: 'My Plug',
      theme: myTheme,
      themeMode: ThemeMode.system,
      home: const Auth(),
    );
  }
}
