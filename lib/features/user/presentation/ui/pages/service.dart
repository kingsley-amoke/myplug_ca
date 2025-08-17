import 'package:flutter/material.dart';
import 'package:myplug_ca/features/user/domain/models/skill.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
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
    context.read<UserProvider>().getUserByService(widget.service);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: widget.service.name),
      body: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider provider, Widget? child) {
          return ListView.builder(
            itemCount: provider.userByService.length,
            itemBuilder: (context, index) {
              final item = provider.userByService[index];
              return Text(item.email);
            },
          );
        },
      ),
    );
  }
}
