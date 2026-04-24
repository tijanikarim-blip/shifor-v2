import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  final String id;
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? photoUrl;
  final String? licenseNumber;
  final String? licensePhotoUrl;
  final String? vehicleType;
  final String? vehiclePlate;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? locationAddress;
  final bool isAvailable;
  final bool isVerified;
  final bool isOnline;
  final int rating;
  final int totalJobs;
  final DateTime createdAt;
  final DateTime? updatedAt;

  DriverModel({
    required this.id,
    required this.userId,
    this.firstName,
    this.lastName,
    this.phone,
    this.photoUrl,
    this.licenseNumber,
    this.licensePhotoUrl,
    this.vehicleType,
    this.vehiclePlate,
    this.address,
    this.latitude,
    this.longitude,
    this.locationAddress,
    this.isAvailable = false,
    this.isVerified = false,
    this.isOnline = false,
    this.rating = 0,
    this.totalJobs = 0,
    required this.createdAt,
    this.updatedAt,
  });

  factory DriverModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DriverModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      firstName: data['firstName'],
      lastName: data['lastName'],
      phone: data['phone'],
      photoUrl: data['photoUrl'],
      licenseNumber: data['licenseNumber'],
      licensePhotoUrl: data['licensePhotoUrl'],
      vehicleType: data['vehicleType'],
      vehiclePlate: data['vehiclePlate'],
      address: data['address'],
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      locationAddress: data['locationAddress'],
      isAvailable: data['isAvailable'] ?? false,
      isVerified: data['isVerified'] ?? false,
      isOnline: data['isOnline'] ?? false,
      rating: data['rating'] ?? 0,
      totalJobs: data['totalJobs'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'photoUrl': photoUrl,
      'licenseNumber': licenseNumber,
      'licensePhotoUrl': licensePhotoUrl,
      'vehicleType': vehicleType,
      'vehiclePlate': vehiclePlate,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'locationAddress': locationAddress,
      'isAvailable': isAvailable,
      'isVerified': isVerified,
      'isOnline': isOnline,
      'rating': rating,
      'totalJobs': totalJobs,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  DriverModel copyWith({
    String? id,
    String? userId,
    String? firstName,
    String? lastName,
    String? phone,
    String? photoUrl,
    String? licenseNumber,
    String? licensePhotoUrl,
    String? vehicleType,
    String? vehiclePlate,
    String? address,
    double? latitude,
    double? longitude,
    String? locationAddress,
    bool? isAvailable,
    bool? isVerified,
    bool? isOnline,
    int? rating,
    int? totalJobs,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DriverModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licensePhotoUrl: licensePhotoUrl ?? this.licensePhotoUrl,
      vehicleType: vehicleType ?? this.vehicleType,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationAddress: locationAddress ?? this.locationAddress,
      isAvailable: isAvailable ?? this.isAvailable,
      isVerified: isVerified ?? this.isVerified,
      isOnline: isOnline ?? this.isOnline,
      rating: rating ?? this.rating,
      totalJobs: totalJobs ?? this.totalJobs,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}