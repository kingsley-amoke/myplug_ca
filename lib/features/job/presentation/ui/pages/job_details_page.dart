import 'package:flutter/material.dart';
import 'package:fixnbuy/core/config/config.dart';
import 'package:fixnbuy/core/constants/images.dart';
import 'package:fixnbuy/core/presentation/ui/widgets/custom_button.dart';
import 'package:fixnbuy/core/presentation/ui/widgets/my_appbar.dart';
import 'package:fixnbuy/features/job/domain/models/job.dart';
import 'package:change_case/change_case.dart';
import 'package:fixnbuy/features/job/presentation/ui/pages/apply_job.dart';

class JobDetailsPage extends StatelessWidget {
  final Job job;
  const JobDetailsPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: 'Job Details'),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          text: 'Apply Now',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ApplyJob(
                  job: job,
                ),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withAlpha(80),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(
                        noUserImage,
                        height: 45,
                        width: 45,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    job.title.toSentenceCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${formatPrice(amount: job.salary)}/month',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Job info row
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildInfoChip(Icons.location_on, job.location),
                      _buildInfoChip(
                          Icons.work_outline, job.type.name.toSentenceCase()),
                      _buildInfoChip(
                          Icons.access_time, formatTimeAgo(job.date)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Description
            const Text(
              'Job Description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              job.description,
              style: const TextStyle(color: Colors.black87, height: 1.4),
            ),

            const SizedBox(height: 24),

            /// Requirements
            const Text(
              'Job Requirements',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              itemCount: job.requirements.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final String requirement = job.requirements[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          requirement.toSentenceCase(),
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 100), // space for bottom button
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      backgroundColor: Colors.white.withAlpha(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      avatar: Icon(icon, color: Colors.black, size: 18),
      label: Text(
        text.toSentenceCase(),
        style: const TextStyle(color: Colors.black, fontSize: 13),
      ),
    );
  }
}
