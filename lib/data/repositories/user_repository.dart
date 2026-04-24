import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/driver_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _usersRef => _firestore.collection('users');

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _usersRef.doc(userId).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      return null;
    }
  }

  Stream<UserModel?> getUserStream(String userId) {
    return _usersRef.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    });
  }

  Future<void> createUser(String userId, Map<String, dynamic> data) async {
    await _usersRef.doc(userId).set(data);
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _usersRef.doc(userId).update(data);
  }

  Future<bool> emailExists(String email) async {
    final result = await _usersRef.where('email', isEqualTo: email.toLowerCase()).limit(1).get();
    return result.docs.isNotEmpty;
  }

  Future<DriverModel?> getDriverProfile(String userId) async {
    try {
      final doc = await _firestore.collection('drivers').doc(userId).get();
      if (!doc.exists) return null;
      return DriverModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      return null;
    }
  }

  Future<void> createDriverProfile(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('drivers').doc(userId).set(data);
  }

  Future<void> updateDriverProfile(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('drivers').doc(userId).update(data);
  }

  Stream<List<DriverModel>> getAvailableDrivers() {
    return _firestore.collection('drivers')
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DriverModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }
}