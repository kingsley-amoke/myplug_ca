import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/bottom_nav.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/signin.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    if(FirebaseAuth.instance.currentUser != null){
      return const BottomNav();
    }else{
      return const LoginPage();
    }
  }
}