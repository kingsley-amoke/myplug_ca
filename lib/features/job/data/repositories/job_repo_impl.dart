import 'dart:io';

import 'package:fixnbuy/features/job/domain/models/application.dart';
import 'package:fixnbuy/features/job/domain/models/job.dart';
import 'package:fixnbuy/features/job/domain/repositories/job_repository.dart';
import 'package:fixnbuy/features/job/services/job_database_service.dart';

class JobRepoImpl extends JobRepository {
  final JobDatabaseService _jobDatabaseService;

  JobRepoImpl(this._jobDatabaseService);

  @override
  Future<Job?> createJob(Job job) async {
    return await _jobDatabaseService.createJob(job);
  }

  @override
  Future<void> deleteJob(String jobId) async {
    return await _jobDatabaseService.deleteJob(jobId);
  }

  @override
  Future<Job> updateJob(Job job) async {
    return await _jobDatabaseService.updateJob(job);
  }

  @override
  Future<Job?> loadJob(String jobId) async {
    return await _jobDatabaseService.loadJob(jobId);
  }

  @override
  Future<List<Job>> loadAllJobs() async {
    return await _jobDatabaseService.loadAllJobs();
  }

  Future<String?> uploadFile({required File file, required String path}) async {
    return await _jobDatabaseService.uploadFile(file: file, path: path);
  }

  @override
  Future<JobApplication> applyJob(JobApplication application) async {
    return await _jobDatabaseService.applyJob(application);
  }

  Future<void> deleteImage(String url) async {
    _jobDatabaseService.deleteImage(url);
  }

  @override
  Future<List<JobApplication>> loadApplications() async {
    return await _jobDatabaseService.loadApplications();
  }
}
