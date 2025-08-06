import 'package:myplug_ca/features/job/domain/models/job.dart';
import 'package:myplug_ca/features/job/domain/repositories/job_repository.dart';

class JobDatabaseService extends JobRepository {
  final JobRepository _databaseService;

  JobDatabaseService(this._databaseService);

  @override
  Future<Job?> createJob(Job job) async {
    return await _databaseService.createJob(job);
  }

  @override
  Future<void> deleteJob(String jobId) async {
    return await _databaseService.deleteJob(jobId);
  }

  @override
  Future<Job> updateJob(Job job) async {
    return await _databaseService.updateJob(job);
  }

  @override
  Future<Job?> loadJob(String jobId) async {
    return await _databaseService.loadJob(jobId);
  }

  @override
  Future<List<Job>> loadAllJobs() async {
    return await _databaseService.loadAllJobs();
  }
}
