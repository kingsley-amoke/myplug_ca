import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myplug_ca/features/job/domain/models/application.dart';
import 'package:myplug_ca/features/job/domain/models/job.dart';
import 'package:myplug_ca/features/job/domain/repositories/job_repository.dart';

class JobFirestoreService extends JobRepository {
  final FirebaseFirestore _firestore;

  JobFirestoreService(this._firestore);

  final _collection = 'jobs';

  @override
  Future<Job?> createJob(Job job) async {
    final jobRef = _firestore.collection(_collection).doc();

    await jobRef.set(job.copyWith(id: jobRef.id).toMap());
    return job.copyWith(id: jobRef.id);
  }

  @override
  Future<void> deleteJob(String jobId) async {
    await _firestore.collection(_collection).doc(jobId).delete();
  }

  @override
  Future<Job> updateJob(Job job) async {
    await _firestore.collection(_collection).doc(job.id).update(job.toMap());

    return job;
  }

  @override
  Future<Job?> loadJob(String jobId) async {
    return await _firestore
        .collection(_collection)
        .doc(jobId)
        .get()
        .then((doc) {
      if (doc.exists) {
        return Job.fromMap(doc.data()!);
      } else {
        return null;
      }
    });
  }

  @override
  Future<List<Job>> loadAllJobs() async {
    return await _firestore.collection(_collection).get().then((doc) {
      return doc.docs.map((e) {
        return Job.fromMap(e.data());
      }).toList();
    });
  }

  @override
  Future<JobApplication> applyJob(JobApplication application) async {
    final applicationRef = _firestore.collection('application').doc();

    await applicationRef.set(application.copyWith(id: application.id).toMap());
    return application.copyWith(id: application.id);
  }
}
