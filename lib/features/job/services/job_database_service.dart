import 'dart:io';

import 'package:myplug_ca/core/domain/repositories/image_upload_repo.dart';
import 'package:myplug_ca/features/job/domain/models/application.dart';
import 'package:myplug_ca/features/job/domain/models/job.dart';
import 'package:myplug_ca/features/job/domain/repositories/job_repository.dart';

class JobDatabaseService extends JobRepository {
  final JobRepository databaseService;
  final FileUploadRepo fileUploadService;

  JobDatabaseService(
      {required this.databaseService, required this.fileUploadService});

  @override
  Future<Job?> createJob(Job job) async {
    return await databaseService.createJob(job);
  }

  @override
  Future<void> deleteJob(String jobId) async {
    return await databaseService.deleteJob(jobId);
  }

  @override
  Future<Job> updateJob(Job job) async {
    return await databaseService.updateJob(job);
  }

  @override
  Future<Job?> loadJob(String jobId) async {
    return await databaseService.loadJob(jobId);
  }

  @override
  Future<List<Job>> loadAllJobs() async {
    return await databaseService.loadAllJobs();
  }

  Future<String?> uploadFile({required File file, required String path}) async {
    return await fileUploadService.uploadFile(file: file, path: path);
  }

  @override
  Future<JobApplication> applyJob(JobApplication application) async {
    return await databaseService.applyJob(application);
  }
}
