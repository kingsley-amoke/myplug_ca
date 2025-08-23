import 'package:flutter/material.dart';
import 'package:change_case/change_case.dart';
import 'package:myplug_ca/features/job/domain/models/application.dart';

class JobApplicationCard extends StatelessWidget {
  final JobApplication application;
  final VoidCallback? onViewResume;
  final VoidCallback? onViewCoverLetter;
  final VoidCallback? onContact;
  final VoidCallback? onEmail;
  final VoidCallback? deleteApplication;

  const JobApplicationCard({
    super.key,
    required this.application,
    this.onViewResume,
    this.onViewCoverLetter,
    this.onContact,
    this.onEmail,
    this.deleteApplication,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name and Actions Row
            Text(
              "${application.firstName.toCapitalCase()} ${application.lastName.toCapitalCase()}",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: onContact,
                      icon: const Icon(Icons.phone, color: Colors.green),
                      tooltip: "Contact Applicant",
                    ),
                    IconButton(
                      onPressed: onEmail,
                      icon: const Icon(Icons.email, color: Colors.blue),
                      tooltip: "Email Applicant",
                    ),
                  ],
                ),
                IconButton(
                  onPressed: deleteApplication,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: "Delete Application",
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Action buttons for resume and cover letter
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: onViewResume,
                  icon: const Icon(Icons.picture_as_pdf, size: 18),
                  label: const Text("Resume"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    foregroundColor: theme.colorScheme.primary,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onViewCoverLetter,
                  icon: const Icon(Icons.description, size: 18),
                  label: const Text("Cover Letter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.withOpacity(0.1),
                    foregroundColor: Colors.orange,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
