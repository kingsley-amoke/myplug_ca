import 'package:flutter/material.dart';
import 'package:myplug_ca/core/constants/skills.dart';
import 'package:myplug_ca/features/user/presentation/ui/pages/service.dart';
import 'package:myplug_ca/core/ui/widgets/my_appbar.dart';

class Services extends StatelessWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: 'All Services'),
      body: ListView.separated(
        itemBuilder: ((context, index) {
          final service = services[index];

          return ListTile(
            title: Text(service.name, style: TextStyle(color: Colors.black)),
            leading: CircleAvatar(child: Image.asset(service.image)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => Service(service: service)),
              );
            },
          );
        }),
        separatorBuilder: (context, index) {
          return Divider(indent: 15);
        },
        itemCount: services.length,
      ),
    );
  }
}
