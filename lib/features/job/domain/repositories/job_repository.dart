import 'package:fixnbuy/features/job/domain/models/application.dart';
import 'package:fixnbuy/features/job/domain/models/job.dart';

abstract class JobRepository {
  Future<Job?> createJob(Job job);
  Future<void> deleteJob(String jobId);
  Future<Job> updateJob(Job job);
  Future<Job?> loadJob(String jobId);
  Future<List<Job>> loadAllJobs();
  Future<JobApplication> applyJob(JobApplication application);
  Future<List<JobApplication>> loadApplications();
}
