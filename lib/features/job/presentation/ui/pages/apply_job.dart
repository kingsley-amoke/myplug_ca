import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fixnbuy/core/config/config.dart';
import 'package:fixnbuy/core/constants/validators.dart';
import 'package:fixnbuy/core/domain/models/toast.dart';
import 'package:fixnbuy/core/presentation/ui/widgets/my_appbar.dart';
import 'package:fixnbuy/core/presentation/ui/widgets/my_input.dart';
import 'package:fixnbuy/features/job/domain/models/document_type.dart';
import 'package:fixnbuy/features/job/domain/models/job.dart';
import 'package:fixnbuy/features/job/presentation/viewmodels/job_provider.dart';
import 'package:fixnbuy/features/user/presentation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

class ApplyJob extends StatefulWidget {
  const ApplyJob({super.key, required this.job});

  final Job job;

  @override
  State<ApplyJob> createState() => _ApplyJobState();
}

class _ApplyJobState extends State<ApplyJob> {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  File? resume;
  File? coverLetter;
  bool _isSubmitting = false;

  Future<void> _pickFile(JobApplicationDocumentType type) async {
    final picked = await pickFile(folder: type.name);

    if (picked != null) {
      setState(() {
        if (type == JobApplicationDocumentType.resume) {
          resume = picked;
        } else {
          coverLetter = picked;
        }
      });
    }
  }

  void _submitApplication(BuildContext context) {
    final user = context.read<UserProvider>();
    final navigator = Navigator.of(context);

    // Validate inputs
    if (firstnameController.text.trim().isEmpty) {
      showToast(message: "First name is required", type: ToastType.error);
      return;
    }
    if (lastnameController.text.trim().isEmpty) {
      showToast(message: "Last name is required", type: ToastType.error);
      return;
    }
    if (phoneController.text.trim().isEmpty) {
      showToast(message: "Phone number is required", type: ToastType.error);
      return;
    }
    if (emailController.text.trim().isEmpty ||
        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text.trim())) {
      showToast(message: "Enter a valid email address", type: ToastType.error);
      return;
    }
    if (resume == null) {
      showToast(message: "Please upload your resume", type: ToastType.error);
      return;
    }
    if (coverLetter == null) {
      showToast(
          message: "Please upload your cover letter", type: ToastType.error);
      return;
    }
    if (!user.isLoggedIn) {
      showToast(
          message: "You must be logged in to apply", type: ToastType.error);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });
    // Submit application
    context
        .read<JobProvider>()
        .applyJob(
          resume: resume!,
          coverLetter: coverLetter!,
          jobId: widget.job.id!,
          firstname: firstnameController.text.trim(),
          lastname: lastnameController.text.trim(),
          phone: phoneController.text.trim(),
          email: emailController.text.trim(),
          userId: user.myplugUser!.id!,
        )
        .then((_) {
      showToast(
          message: 'Application submitted successfully',
          type: ToastType.success);
      navigator.popAndPushNamed('/');
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, title: 'Apply Job'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Section: Personal Info
            Text(
              "Personal Information",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            MyInput(
              controller: firstnameController,
              hintText: "First Name",
              prefixIcon: const Icon(Icons.person_outline),
              validator: (v) => textValidator(v),
            ),
            const SizedBox(height: 12),

            MyInput(
              controller: lastnameController,
              hintText: "Last Name",
              prefixIcon: const Icon(Icons.person_outline),
              validator: (v) => textValidator(v),
            ),
            const SizedBox(height: 12),

            MyInput(
              controller: phoneController,
              hintText: "Phone Number",
              prefixIcon: const Icon(Icons.phone_outlined),
              validator: (v) => textValidator(v),
            ),
            const SizedBox(height: 12),

            MyInput(
              controller: emailController,
              hintText: "Email Address",
              prefixIcon: const Icon(Icons.email),
              validator: (v) => textValidator(v),
            ),
            const SizedBox(height: 24),

            /// Section: Documents
            Text(
              "Attachments",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            /// Resume Upload
            _UploadCard(
              title: "Upload Resume",
              subtitle: "PDF, DOCX (Max 5MB)",
              icon: Icons.upload_file,
              onTap: () => _pickFile(JobApplicationDocumentType.resume),
              fileName: resume?.path.split('/').last,
            ),
            const SizedBox(height: 12),

            /// Cover Letter Upload
            _UploadCard(
              title: "Upload Cover Letter",
              subtitle: "Optional • PDF, DOCX",
              icon: Icons.description_outlined,
              onTap: () => _pickFile(JobApplicationDocumentType.coverletter),
              fileName: coverLetter?.path.split('/').last,
            ),
            const SizedBox(height: 32),

            /// Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _isSubmitting ? null : () => _submitApplication(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        "Submit Application",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Minimalistic upload card widget
class _UploadCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final String? fileName;

  const _UploadCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row
            Row(
              children: [
                Icon(icon, size: 32, color: Theme.of(context).primaryColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.black45),
              ],
            ),

            /// File name (if available)
            if (fileName != null) ...[
              const SizedBox(height: 12),
              Text(
                fileName!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
