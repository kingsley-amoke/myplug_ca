import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: 'Settings'),
    );
  }
}