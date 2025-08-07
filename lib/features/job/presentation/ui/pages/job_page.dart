import 'package:flutter/material.dart';
import 'package:myplug_ca/core/constants/nigerian_states.dart';
import 'package:myplug_ca/core/constants/shops.dart';
import 'package:myplug_ca/core/models/filter.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/custom_button.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/modular_search_filter_bar.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/job/domain/models/job.dart';
import 'package:myplug_ca/features/job/domain/models/job_type.dart';
import 'package:myplug_ca/features/job/presentation/ui/widgets/job_item.dart';
import 'package:myplug_ca/features/job/presentation/viewmodels/job_provider.dart';
import 'package:provider/provider.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  final List<JobType> jobtypes = [
    JobType.fulltime,
    JobType.internship,
    JobType.parttime,
    JobType.remote,
  ];

  List<Job> filteredJobs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: 'Jobs', implyLeading: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'Land your dream job with our professional cv review'),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                      text: 'Check it out Now!',
                      onPressed: () {
                        //TODO: implement cv review page
                      }),
                ],
              ),
            ),
            ModularSearchFilterBar(
              onSearch: (search, filters) {
                context.read<JobProvider>().filterByParams(
                    location: filters['location'],
                    jobType: filters['jobType'],
                    minSalary: filters['salary']);
              },
              jobTypes: jobtypes,
              locations: nigerianStates,
            ),
            Consumer<JobProvider>(
              builder: (BuildContext context, JobProvider provider, _) {
                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: provider.filteredJobs.length,
                    itemBuilder: (context, index) {
                      final Job job = provider.filteredJobs[index];
                      return JobItem(job: job);
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
