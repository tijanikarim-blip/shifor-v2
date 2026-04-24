class DriverModel {
  final String id;
  final String driverId;
  final String name;
  final List<String> licenses;
  final int experienceYears;
  final List<String> languages;
  final bool isAvailable;
  final double rating;
  final double? latitude;
  final double? longitude;
  final String? currentCity;
  final String? profileImageUrl;
  final String? licenseImageUrl;
  final List<String> attestationUrls;
  final String verificationStatus;
  final DateTime createdAt;

  DriverModel({
    required this.id,
    required this.driverId,
    required this.name,
    this.licenses = const [],
    this.experienceYears = 0,
    this.languages = const [],
    this.isAvailable = false,
    this.rating = 0,
    this.latitude,
    this.longitude,
    this.currentCity,
    this.profileImageUrl,
    this.licenseImageUrl,
    this.attestationUrls = const [],
    this.verificationStatus = 'pending',
    required this.createdAt,
  });

  factory DriverModel.fromMap(Map<String, dynamic> map, String id) {
    return DriverModel(
      id: id,
      driverId: map['driverId'] ?? '',
      name: map['name'] ?? '',
      licenses: List<String>.from(map['licenses'] ?? []),
      experienceYears: map['experienceYears'] ?? 0,
      languages: List<String>.from(map['languages'] ?? []),
      isAvailable: map['isAvailable'] ?? false,
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      currentCity: map['currentCity'],
      profileImageUrl: map['profileImageUrl'],
      licenseImageUrl: map['licenseImageUrl'],
      attestationUrls: List<String>.from(map['attestationUrls'] ?? []),
      verificationStatus: map['verificationStatus'] ?? 'pending',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'driverId': driverId,
      'name': name,
      'licenses': licenses,
      'experienceYears': experienceYears,
      'languages': languages,
      'isAvailable': isAvailable,
      'rating': rating,
      'latitude': latitude,
      'longitude': longitude,
      'currentCity': currentCity,
      'profileImageUrl': profileImageUrl,
      'licenseImageUrl': licenseImageUrl,
      'attestationUrls': attestationUrls,
      'verificationStatus': verificationStatus,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}