import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job_model.dart';

class JobRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _jobsRef => _firestore.collection('jobs');

  Future<List<JobModel>> getJobs({int limit = 20}) async {
    final snapshot = await _jobsRef
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => JobModel.fromMap(doc.data(), doc.id)).toList();
  }

  Stream<List<JobModel>> getJobsStream({int limit = 20}) {
    return _jobsRef
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => JobModel.fromMap(doc.data(), doc.id)).toList());
  }

  Future<JobModel?> getJob(String jobId) async {
    final doc = await _jobsRef.doc(jobId).get();
    if (!doc.exists) return null;
    return JobModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Stream<JobModel?> getJobStream(String jobId) {
    return _jobsRef.doc(jobId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return JobModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    });
  }

  Future<List<JobModel>> getJobsByCompany(String companyId) async {
    final snapshot = await _jobsRef
        .where('companyId', isEqualTo: companyId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => JobModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<JobModel>> getJobsByCountry(String country) async {
    final snapshot = await _jobsRef
        .where('country', isEqualTo: country)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => JobModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<String> createJob(Map<String, dynamic> data) async {
    final docRef = await _jobsRef.add(data);
    return docRef.id;
  }

  Future<void> updateJob(String jobId, Map<String, dynamic> data) async {
    await _jobsRef.doc(jobId).update(data);
  }

  Future<void> deleteJob(String jobId) async {
    await _jobsRef.doc(jobId).update({'isActive': false});
  }
}