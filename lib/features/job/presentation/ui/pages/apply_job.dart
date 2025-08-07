import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_input.dart';

class ApplyJob extends StatelessWidget {
  ApplyJob({super.key});

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: 'Apply Job'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('First Name'),
              MyInput(
                controller: firstnameController,
                prefixIcon: const Icon(Icons.person),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Last Name'),
              MyInput(
                controller: lastnameController,
                prefixIcon: const Icon(Icons.person),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Phone Number'),
              MyInput(
                controller: phoneController,
                prefixIcon: const Icon(Icons.phone),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Address'),
              MyInput(
                controller: addressController,
                prefixIcon: const Icon(Icons.location_city),
              ),
              const SizedBox(
                height: 10,
              ),
              //TODO: upload resume
            ],
          ),
        ),
      ),
    );
  }
}
