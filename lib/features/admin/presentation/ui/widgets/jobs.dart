import 'package:flutter/material.dart';
import 'package:fixnbuy/core/presentation/ui/widgets/modular_search_filter_bar.dart';
import 'package:fixnbuy/features/admin/presentation/ui/widgets/job_card.dart';
import 'package:fixnbuy/features/job/presentation/ui/pages/add_job.dart';
import 'package:fixnbuy/features/job/presentation/viewmodels/job_provider.dart';
import 'package:provider/provider.dart';

class JobsSection extends StatefulWidget {
  const JobsSection({super.key});

  @override
  State<JobsSection> createState() => _JobsSectionState();
}

class _JobsSectionState extends State<JobsSection> {
  @override
  void initState() {
    super.initState();

    context.read<JobProvider>().initFilteredJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<JobProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              ModularSearchFilterBar(
                  showFilterIcon: false,
                  onSearch: (search, _) {
                    context
                        .read<JobProvider>()
                        .filterByParams(searchTerm: search);
                  }),
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.all(5),
                  itemCount: provider.filteredJobs.length,
                  itemBuilder: (context, index) {
                    final job = provider.filteredJobs[index];
                    return JobCard(job: job);
                  },
                ),
              ),
            ],
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
