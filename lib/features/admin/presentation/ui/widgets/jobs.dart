import 'package:flutter/material.dart';
import 'package:myplug_ca/features/admin/presentation/ui/widgets/job_card.dart';
import 'package:myplug_ca/features/job/domain/models/job_type.dart';
import 'package:myplug_ca/features/job/presentation/ui/pages/add_job.dart';
import 'package:myplug_ca/features/job/presentation/viewmodels/job_provider.dart';
import 'package:provider/provider.dart';

class Job {
  final String? id;
  final String title;
  final String description;
  final JobType type;
  final double salary;
  final String company;
  final String companyLogo;
  final String location;
  final DateTime date;
  final List<String> requirements;

  const Job({
    this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.location,
    required this.company,
    required this.companyLogo,
    required this.salary,
    required this.requirements,
    required this.date,
  });
}

class JobsSection extends StatelessWidget {
  const JobsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<JobProvider>(
        builder: (context, provider, _) {
          return ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: provider.jobs.length,
            itemBuilder: (context, index) {
              final job = provider.jobs[index];
              return JobCard(job: job);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddJobPage()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2,
        child: const Icon(
          Icons.add_rounded,
          size: 28,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
