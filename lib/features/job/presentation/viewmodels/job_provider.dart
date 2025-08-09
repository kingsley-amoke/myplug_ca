import 'package:flutter/foundation.dart';
import 'package:myplug_ca/core/constants/jobs.dart';
import 'package:myplug_ca/features/job/data/repositories/job_repo_impl.dart';
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

  List<Job> filterByParams<T>({
    // required List<T> items,
    String? location,
    String? jobType,
    double? minSalary,
  }) {
    List<Job> matches = [];
    for (Job item in _jobs) {
      if (minSalary == null && location == null && jobType == null) {
        matches = _jobs;
      }

      if (location != null && jobType != null && minSalary != null) {
        // matches.clear();
        if (item.salary >= minSalary) {
          matches.add(item);
        }
        if (jobType == item.type.name) {
          matches.add(item);
        }
        if (location.toLowerCase() == item.location.toLowerCase()) {
          matches.add(item);
        }
      }

      if (location != null && jobType != null && minSalary == null) {
        // matches.clear();
        if (jobType == item.type.name) {
          matches.add(item);
        }
        if (location.toLowerCase() == item.location.toLowerCase()) {
          matches.add(item);
        }
      }

      if (location != null && minSalary != null && jobType == null) {
        // matches.clear();
        if (item.salary >= minSalary) {
          matches.add(item);
        }
        if (location.toLowerCase() == item.location.toLowerCase()) {
          matches.add(item);
        }
      }
      if (jobType != null && minSalary != null && location == null) {
        // matches.clear();
        if (item.salary >= minSalary) {
          matches.add(item);
        }
        if (jobType == item.type.name) {
          matches.add(item);
        }
      }

      if (location != null) {
        if (item.location.toLowerCase() == location.toLowerCase()) {
          matches.add(item);
        }
      }

      if (jobType != null) {
        if (item.type.name.toLowerCase() == jobType.toLowerCase()) {
          matches.add(item);
        }
      }
      if (minSalary != null) {
        if (item.salary >= minSalary) {
          matches.add(item);
        }
      }
    }

    filteredJobs = matches;

    notifyListeners();
    return matches;
  }

  Future<void> deleteJob(MyplugUser user, String jobId) async {
    if (user.isAdmin) {
      await _jobRepoImpl.deleteJob(jobId);

      _jobs.removeWhere((job) => job.id == jobId);
      notifyListeners();
    }
  }
}
