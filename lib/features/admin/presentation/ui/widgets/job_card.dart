import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/features/job/domain/models/job.dart';
import 'package:myplug_ca/features/job/domain/models/job_type.dart';

class JobCard extends StatelessWidget {
  const JobCard({super.key, required this.job});

  final Job job;

  String _formatJobType(JobType type) {
    switch (type) {
      case JobType.fulltime:
        return "Full-time";
      case JobType.parttime:
        return "Part-time";
      case JobType.remote:
        return "Remote";
      case JobType.internship:
        return "Internship";
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
                        _formatJobType(job.type),
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
                    case "add":
                      // TODO: Add Job
                      break;
                    case "edit":
                      // TODO: Edit Job
                      break;
                    case "delete":
                      // TODO: Delete Job
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: "add",
                    child: Text("Add Job"),
                  ),
                  const PopupMenuItem(
                    value: "edit",
                    child: Text("Edit Job"),
                  ),
                  const PopupMenuItem(
                    value: "delete",
                    child: Text("Delete Job"),
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
