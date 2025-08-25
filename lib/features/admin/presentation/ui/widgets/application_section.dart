import 'package:flutter/material.dart';
import 'package:fixnbuy/features/admin/presentation/ui/widgets/application_card.dart';
import 'package:fixnbuy/features/job/presentation/viewmodels/job_provider.dart';
import 'package:provider/provider.dart';

class ApplicationSection extends StatelessWidget {
  const ApplicationSection({super.key});

  void phoneContact() {}
  void emailContact() {}
  void viewResume() {}
  void viewCoverLetter() {}
  Future<void> deleteApplication() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<JobProvider>(builder: (context, provider, _) {
        return ListView.builder(
            itemCount: provider.applications.length,
            itemBuilder: (context, index) {
              final application = provider.applications[index];
              return JobApplicationCard(
                application: application,
                onContact: phoneContact,
                onEmail: emailContact,
                onViewCoverLetter: viewCoverLetter,
                onViewResume: viewResume,
                deleteApplication: deleteApplication,
              );
            });
      }),
    );
  }
}
