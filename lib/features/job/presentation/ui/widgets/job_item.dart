import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/images.dart';
import 'package:myplug_ca/features/job/domain/models/job.dart';
import 'package:change_case/change_case.dart';
import 'package:myplug_ca/features/job/presentation/ui/pages/job_details_page.dart';

class JobItem extends StatelessWidget {
  final Job job;
  const JobItem({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => JobDetailsPage(job: job),
          ),
        );
      },
      child: Container(
        height: 150,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Image.asset(
                  noUserImage,
                  height: 40,
                  width: 40,
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(job.title),
                ),
              ],
            ),
            Text(
              formatPrice(amount: job.salary),
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_city),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(job.location),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.work),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(job.type.name.toSentenceCase()),
                      ],
                    )
                  ],
                ),
                Text(formatTimeAgo(job.date)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
