import 'package:flutter/material.dart';
import 'package:myplug_ca/core/constants/nigerian_states.dart';
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

  @override
  void initState() {
    context.read<JobProvider>().initFilteredJobs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: 'Jobs', implyLeading: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---- Job Search Bar ----
            ModularSearchFilterBar(
              onSearch: (search, filters) {
                context.read<JobProvider>().filterByParams(
                      location: filters['location'],
                      jobType: filters['jobType'],
                      minSalary: filters['salary'],
                      searchTerm: search,
                    );
              },
              jobTypes: jobtypes,
              locations: nigerianStates,
            ),
            // ---- CV Review Section ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                elevation: 0,
                color: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: Icon(
                    Icons.article_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                  title: Text(
                    "CV Review",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  subtitle: const Text(
                    "Stand out with a professionally reviewed CV.",
                    style: TextStyle(fontSize: 13),
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/cv-review");
                    },
                    child: const Text("Get Started"),
                  ),
                ),
              ),
            ),

            // ---- Job List ----
            Consumer<JobProvider>(
              builder: (BuildContext context, JobProvider provider, _) {
                return provider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: provider.filteredJobs.length,
                        itemBuilder: (context, index) {
                          final Job job = provider.filteredJobs[index];
                          return JobItem(job: job);
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
