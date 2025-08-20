import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:myplug_ca/core/constants/jobs.dart';
import 'package:myplug_ca/features/job/data/repositories/job_repo_impl.dart';
import 'package:myplug_ca/features/job/domain/models/application.dart';
import 'package:myplug_ca/features/job/domain/models/document_type.dart';
import 'package:myplug_ca/features/job/domain/models/job.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

class JobProvider extends ChangeNotifier {
  final JobRepoImpl _jobRepoImpl;

  JobProvider(this._jobRepoImpl);

  List<Job> _jobs = demoJobs;
  List<Job> get jobs => _jobs;
  List<Job> filteredJobs = [];

  Future<void> loadJobs() async {
    _jobs = await _jobRepoImpl.loadAllJobs();
    notifyListeners();
  }

  Future<Job?> loadJob(String jobId) async {
    return await _jobRepoImpl.loadJob(jobId);
  }

  Future<void> updateJob(Job job) async {
    final updatedJob = await _jobRepoImpl.updateJob(job);

    _jobs.remove(job);
    _jobs.add(updatedJob);

    notifyListeners();
  }

  void initFilteredJobs() {
    filteredJobs = _jobs;
  }

  List<Job> filterByParams({
    String? location,
    String? jobType,
    double? minSalary,
    String? searchTerm,
  }) {
    List<Job> matches = [];

    for (Job item in _jobs) {
      bool match = true;

      // Location filter
      if (location != null &&
          item.location.toLowerCase() != location.toLowerCase()) {
        match = false;
      }

      // Job type filter
      if (jobType != null &&
          item.type.name.toLowerCase() != jobType.toLowerCase()) {
        match = false;
      }

      // Salary filter
      if (minSalary != null && item.salary < minSalary) {
        match = false;
      }

      // Search term filter (ignore if null or empty)
      if (searchTerm != null && searchTerm.trim().isNotEmpty) {
        final term = searchTerm.toLowerCase();
        final title = item.title.toLowerCase();
        final description = item.description.toLowerCase();

        if (!(title.contains(term) || description.contains(term))) {
          match = false;
        }
      }

      if (match) {
        matches.add(item);
      }
    }

    filteredJobs = matches;
    notifyListeners();
    return matches;
  }

  Future<void> applyJob({
    required File resume,
    required File coverLetter,
    required String jobId,
    required String firstname,
    required String lastname,
    required String phone,
    required String email,
    required String userId,
  }) async {
    final resumeDownloadUrl = await _jobRepoImpl.uploadFile(
      file: resume,
      path: JobApplicationDocumentType.resume.name,
    );

    final coverLetterDownloadUrl = await _jobRepoImpl.uploadFile(
      file: coverLetter,
      path: JobApplicationDocumentType.coverletter.name,
    );

    if (resumeDownloadUrl != null && coverLetterDownloadUrl != null) {
      final application = JobApplication(
        jobId: jobId,
        userId: userId,
        resumeUrl: resumeDownloadUrl,
        coverLetterUrl: coverLetterDownloadUrl,
        firstName: firstname,
        lastName: lastname,
        email: email,
        phone: phone,
      );

      await _jobRepoImpl.applyJob(application);
    }
  }

  Future<void> deleteJob(MyplugUser user, String jobId) async {
    if (user.isAdmin) {
      await _jobRepoImpl.deleteJob(jobId);

      _jobs.removeWhere((job) => job.id == jobId);
      notifyListeners();
    }
  }
}
