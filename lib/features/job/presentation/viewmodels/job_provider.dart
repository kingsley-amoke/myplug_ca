import 'package:flutter/foundation.dart';
import 'package:myplug_ca/core/constants/jobs.dart';
import 'package:myplug_ca/features/job/data/repositories/job_repo_impl.dart';
import 'package:myplug_ca/features/job/domain/models/job.dart';

class JobProvider extends ChangeNotifier {
  final JobRepoImpl _jobRepoImpl;

  JobProvider(this._jobRepoImpl);

  List<Job> _jobs = demoJobs;
  List<Job> get jobs => _jobs;

  Future<void> loadJobs() async {
    _jobs = await _jobRepoImpl.loadAllJobs();
    notifyListeners();
  }

  Future<Job?> loadJob(String jobId) async {
    return await _jobRepoImpl.loadJob(jobId);
  }

  Future<void> deleteJob(String jobId) async {
    await _jobRepoImpl.deleteJob(jobId);

    _jobs.removeWhere((job) => job.id == jobId);
    notifyListeners();
  }

  Future<void> updateJob(Job job) async {
    final updatedJob = await _jobRepoImpl.updateJob(job);

    _jobs.remove(job);
    _jobs.add(updatedJob);

    notifyListeners();
  }
}
