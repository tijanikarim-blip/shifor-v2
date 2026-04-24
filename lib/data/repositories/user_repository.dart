import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

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

  Future<void> deleteUser(String userId) async {
    await _usersRef.doc(userId).delete();
  }

  Future<bool> emailExists(String email) async {
    final result = await _usersRef.where('email', isEqualTo: email.toLowerCase()).limit(1).get();
    return result.docs.isNotEmpty;
  }

  Future<DriverProfileModel?> getDriverProfile(String userId) async {
    try {
      final doc = await _firestore.collection('drivers').doc(userId).get();
      if (!doc.exists) return null;
      return DriverProfileModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
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

  Future<CompanyProfileModel?> getCompanyProfile(String userId) async {
    try {
      final doc = await _firestore.collection('companies').doc(userId).get();
      if (!doc.exists) return null;
      return CompanyProfileModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      return null;
    }
  }

  Future<void> createCompanyProfile(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('companies').doc(userId).set(data);
  }

  Future<void> updateCompanyProfile(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('companies').doc(userId).update(data);
  }

  Stream<List<DriverProfileModel>> getAvailableDrivers() {
    return _firestore.collection('drivers')
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DriverProfileModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }
}

class DriverProfileModel {
  final String id;
  final String driverId;
  final List<String> licenses;
  final int experienceYears;
  final List<String> languages;
  final bool isAvailable;
  final double rating;
  final String? currentCity;
  final String? profileImageUrl;
  final String? licenseImageUrl;
  final String verificationStatus;
  final DateTime createdAt;

  DriverProfileModel({
    required this.id,
    required this.driverId,
    this.licenses = const [],
    this.experienceYears = 0,
    this.languages = const [],
    this.isAvailable = false,
    this.rating = 0,
    this.currentCity,
    this.profileImageUrl,
    this.licenseImageUrl,
    this.verificationStatus = 'pending',
    required this.createdAt,
  });

  factory DriverProfileModel.fromMap(Map<String, dynamic> map, String id) {
    return DriverProfileModel(
      id: id,
      driverId: map['driverId'] ?? '',
      licenses: List<String>.from(map['licenses'] ?? []),
      experienceYears: map['experienceYears'] ?? 0,
      languages: List<String>.from(map['languages'] ?? []),
      isAvailable: map['isAvailable'] ?? false,
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      currentCity: map['currentCity'],
      profileImageUrl: map['profileImageUrl'],
      licenseImageUrl: map['licenseImageUrl'],
      verificationStatus: map['verificationStatus'] ?? 'pending',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
    );
  }
}

class CompanyProfileModel {
  final String id;
  final String companyId;
  final String companyName;
  final String country;
  final String? logoUrl;
  final bool verified;
  final String verificationStatus;

  CompanyProfileModel({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.country,
    this.logoUrl,
    this.verified = false,
    this.verificationStatus = 'pending',
  });

  factory CompanyProfileModel.fromMap(Map<String, dynamic> map, String id) {
    return CompanyProfileModel(
      id: id,
      companyId: map['companyId'] ?? '',
      companyName: map['companyName'] ?? '',
      country: map['country'] ?? '',
      logoUrl: map['logoUrl'],
      verified: map['verified'] ?? false,
      verificationStatus: map['verificationStatus'] ?? 'pending',
    );
  }
}