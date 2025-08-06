import 'package:myplug_ca/features/job/domain/models/job.dart';

abstract class JobRepository {
  Future<Job?> createJob(Job job);
  Future<void> deleteJob(String jobId);
  Future<Job> updateJob(Job job);
  Future<Job?> loadJob(String jobId);
  Future<List<Job>> loadAllJobs();
}
