import 'package:flutter/material.dart';
import 'package:myplug_ca/features/user/domain/models/skill.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/core/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class Service extends StatefulWidget {
  const Service({super.key, required this.service});

  final Skill service;

  @override
  State<Service> createState() => _ServiceState();
}

List<MyplugUser> users = [];

class _ServiceState extends State<Service> {
  @override
  void initState() {
    // users = context.read<UserProvider>().getUserByService(widget.service.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: widget.service.name),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final item = users[index];
          return Text(item.email);
        },
      ),
    );
  }
}
