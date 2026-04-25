import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/application_model.dart';

class ApplicationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _appsRef => _firestore.collection('applications');

  Future<List<ApplicationModel>> getApplicationsByDriver(String driverId) async {
    final snapshot = await _appsRef
        .where('driverId', isEqualTo: driverId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => ApplicationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Stream<List<ApplicationModel>> getApplicationsByDriverStream(String driverId) {
    return _appsRef
        .where('driverId', isEqualTo: driverId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ApplicationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Future<List<ApplicationModel>> getApplicationsByJob(String jobId) async {
    final snapshot = await _appsRef
        .where('jobId', isEqualTo: jobId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => ApplicationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Stream<List<ApplicationModel>> getApplicationsByJobStream(String jobId) {
    return _appsRef
        .where('jobId', isEqualTo: jobId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ApplicationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Future<String> createApplication(Map<String, dynamic> data) async {
    final docRef = await _appsRef.add(data);
    return docRef.id;
  }

  Future<void> updateApplicationStatus(String appId, String status) async {
    await _appsRef.doc(appId).update({
      'status': status,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteApplication(String appId) async {
    await _appsRef.doc(appId).delete();
  }

  Future<bool> hasApplied(String jobId, String driverId) async {
    final snapshot = await _appsRef
        .where('jobId', isEqualTo: jobId)
        .where('driverId', isEqualTo: driverId)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }
}