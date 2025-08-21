import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:myplug_ca/features/job/data/repositories/job_repo_impl.dart';
import 'package:myplug_ca/features/job/domain/models/application.dart';
import 'package:myplug_ca/features/job/domain/models/document_type.dart';
import 'package:myplug_ca/features/job/domain/models/job.dart';
import 'package:myplug_ca/features/job/domain/models/job_type.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

class JobProvider extends ChangeNotifier {
  final JobRepoImpl _jobRepoImpl;

  JobProvider(this._jobRepoImpl);

  List<Job> _jobs = [];
  List<Job> get jobs => _jobs;
  List<Job> filteredJobs = [];

  bool isLoading = false;

  Future<void> loadJobs() async {
    _jobs = await _jobRepoImpl.loadAllJobs();
    notifyListeners();
  }

  Future<Job?> loadJob(String jobId) async {
    return await _jobRepoImpl.loadJob(jobId);
  }

  Future<void> updateJob({
    required Job job,
  }) async {
    await _jobRepoImpl.updateJob(job);

    notifyListeners();
  }

  void initFilteredJobs() {
    isLoading = true;
    filteredJobs = _jobs;
    isLoading = false;
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

  Future<void> addJob({
    required File compantLogo,
    required String title,
    required String description,
    required String companyName,
    required double salary,
    required String location,
    required List<String> requirements,
    required JobType type,
  }) async {
    final url =
        await _jobRepoImpl.uploadFile(file: compantLogo, path: 'company_logos');
    if (url != null) {
      final job = Job(
        title: title,
        description: description,
        type: type,
        location: location,
        company: companyName,
        companyLogo: url,
        salary: salary,
        requirements: requirements,
        date: DateTime.now(),
      );

      await _jobRepoImpl.createJob(job);
      _jobs.add(job);
      notifyListeners();
    }
  }

  Future<void> editJob({
    required MyplugUser user,
    required Job job,
    required String title,
    required String description,
    required JobType type,
    required double salary,
    required String location,
    required String company,
    required List<String> requirements,
  }) async {
    if (user.isAdmin) {
      final updatedJob = job.copyWith(
        title: title,
        description: description,
        type: type,
        salary: salary,
        location: location,
        company: company,
        requirements: requirements,
      );

      await updateJob(job: updatedJob);

      _jobs.remove(job);
      _jobs.add(updatedJob);
    }
  }

  Future<void> deleteJob({required MyplugUser user, required Job job}) async {
    if (user.isAdmin) {
      await _jobRepoImpl.deleteJob(job.id!);
      _jobRepoImpl.deleteImage(job.companyLogo);

      _jobs.remove(job);
      notifyListeners();
    }
  }
}
