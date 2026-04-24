import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../models/job_model.dart';
import '../models/application_model.dart';
import '../models/driver_model.dart';

class JobRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<JobModel>> getJobs({
    String? companyId,
    bool activeOnly = true,
  }) async {
    Query query = _firestore.collection(AppConstants.jobsCollection);
    
    if (companyId != null) {
      query = query.where('companyId', isEqualTo: companyId);
    }
    if (activeOnly) {
      query = query.where('isActive', isEqualTo: true);
    }
    
    final snapshot = await query.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => JobModel.fromFirestore(doc)).toList();
  }

  Future<JobModel?> getJob(String jobId) async {
    final doc = await _firestore.collection(AppConstants.jobsCollection).doc(jobId).get();
    if (doc.exists) {
      return JobModel.fromFirestore(doc);
    }
    return null;
  }

  Future<String> createJob(JobModel job) async {
    final doc = await _firestore.collection(AppConstants.jobsCollection).add(job.toFirestore());
    return doc.id;
  }

  Future<void> updateJob(String jobId, Map<String, dynamic> data) async {
    data['updatedAt'] = Timestamp.fromDate(DateTime.now());
    await _firestore.collection(AppConstants.jobsCollection).doc(jobId).update(data);
  }

  Future<void> deleteJob(String jobId) async {
    await _firestore.collection(AppConstants.jobsCollection).doc(jobId).update({
      'isActive': false,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<List<JobModel>> searchJobs(String query) async {
    final snapshot = await _firestore
        .collection(AppConstants.jobsCollection)
        .where('isActive', isEqualTo: true)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: '$query\uf8ff')
        .get();
    return snapshot.docs.map((doc) => JobModel.fromFirestore(doc)).toList();
  }

  Future<String> applyForJob(ApplicationModel application) async {
    final doc = await _firestore
        .collection(AppConstants.applicationsCollection)
        .add(application.toFirestore());
    
    await _firestore.collection(AppConstants.jobsCollection).doc(application.jobId).update({
      'currentApplications': FieldValue.increment(1),
    });
    
    return doc.id;
  }

  Future<List<ApplicationModel>> getApplications({
    String? driverId,
    String? companyId,
    String? jobId,
  }) async {
    Query query = _firestore.collection(AppConstants.applicationsCollection);
    
    if (driverId != null) {
      query = query.where('driverId', isEqualTo: driverId);
    }
    if (companyId != null) {
      query = query.where('companyId', isEqualTo: companyId);
    }
    if (jobId != null) {
      query = query.where('jobId', isEqualTo: jobId);
    }
    
    final snapshot = await query.orderBy('appliedAt', descending: true).get();
    return snapshot.docs.map((doc) => ApplicationModel.fromFirestore(doc)).toList();
  }

  Future<void> updateApplicationStatus(
    String applicationId,
    String status,
  ) async {
    await _firestore.collection(AppConstants.applicationsCollection).doc(applicationId).update({
      'status': status,
      'reviewedAt': Timestamp.fromDate(DateTime.now()),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<List<DriverModel>> getAvailableDrivers() async {
    final snapshot = await _firestore
        .collection(AppConstants.driversCollection)
        .where('isAvailable', isEqualTo: true)
        .where('isVerified', isEqualTo: true)
        .get();
    return snapshot.docs.map((doc) => DriverModel.fromFirestore(doc)).toList();
  }

  Stream<JobModel> jobStream(String jobId) {
    return _firestore.collection(AppConstants.jobsCollection).doc(jobId).snapshots().map(
      (doc) => JobModel.fromFirestore(doc),
    );
  }

  Stream<List<ApplicationModel>> applicationsStream({required String userId, required String role}) {
    if (role == AppConstants.roleDriver) {
      return _firestore
          .collection(AppConstants.applicationsCollection)
          .where('driverId', isEqualTo: userId)
          .snapshots()
          .map((snap) => snap.docs.map((doc) => ApplicationModel.fromFirestore(doc)).toList());
    }
    return _firestore
        .collection(AppConstants.applicationsCollection)
        .where('companyId', isEqualTo: userId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => ApplicationModel.fromFirestore(doc)).toList());
  }
}