import 'package:flutter/material.dart';
import 'package:fixnbuy/core/config/config.dart';
import 'package:fixnbuy/features/job/domain/models/job.dart';
import 'package:fixnbuy/features/job/presentation/ui/pages/edit_job.dart';
import 'package:fixnbuy/features/job/presentation/ui/pages/job_details_page.dart';
import 'package:fixnbuy/features/job/presentation/viewmodels/job_provider.dart';
import 'package:fixnbuy/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.job});

  final Job job;

  void _viewJob(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => JobDetailsPage(job: job),
      ),
    );
  }

  void _editJob(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditJobPage(job: job),
      ),
    );
  }

  void _deleteJob(BuildContext context) {
    final user = context.read<UserProvider>();

    if (user.isLoggedIn) {
      context.read<JobProvider>().deleteJob(user: user.myplugUser!, job: job);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Company Logo
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(job.companyLogo),
              backgroundColor: Colors.grey.shade100,
            ),
            const SizedBox(width: 10),

            // Job Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Title
                  Text(
                    job.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 2),

                  // Company Name
                  Text(
                    job.company,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 6),

                  // Location + Job Type
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          job.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.work_outline,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        formatJobType(job.type),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Salary + Date
                  Row(
                    children: [
                      Text(
                        formatPrice(amount: job.salary),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          formatTimeAgo(job.date),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action Menu (fixed width so it doesn’t push content)
            SizedBox(
              width: 36,
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case "view":
                      _viewJob(context);
                      break;
                    case "edit":
                      _editJob(context);
                      break;
                    case "delete":
                      _deleteJob(context);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: "view",
                    child: Text("View"),
                  ),
                  const PopupMenuItem(
                    value: "edit",
                    child: Text("Edit"),
                  ),
                  const PopupMenuItem(
                    value: "delete",
                    child: Text("Delete"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
