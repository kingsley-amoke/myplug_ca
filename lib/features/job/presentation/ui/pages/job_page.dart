import 'package:flutter/material.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/custom_button.dart';
import 'package:myplug_ca/core/presentation/ui/widgets/my_appbar.dart';
import 'package:myplug_ca/features/job/domain/models/job.dart';
import 'package:myplug_ca/features/job/presentation/ui/widgets/job_item.dart';
import 'package:myplug_ca/features/job/presentation/viewmodels/job_provider.dart';
import 'package:provider/provider.dart';

class JobPage extends StatelessWidget {
  const JobPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: 'Jobs'),
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
            Consumer<JobProvider>(
              builder: (BuildContext context, JobProvider provider, _) {
                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: provider.jobs.length,
                    itemBuilder: (context, index) {
                      final Job job = provider.jobs[index];
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
