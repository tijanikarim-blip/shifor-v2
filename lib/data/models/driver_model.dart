class DriverModel {
  final String id;
  final String driverId;
  final List<String> licenses;
  final int experienceYears;
  final List<String> languages;
  final List<String> countriesWorked;
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
  final DateTime? updatedAt;

  DriverModel({
    required this.id,
    required this.driverId,
    this.licenses = const [],
    this.experienceYears = 0,
    this.languages = const [],
    this.countriesWorked = const [],
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
    this.updatedAt,
  });

  factory DriverModel.fromMap(Map<String, dynamic> map, String id) {
    return DriverModel(
      id: id,
      driverId: map['driverId'] ?? '',
      licenses: List<String>.from(map['licenses'] ?? []),
      experienceYears: map['experienceYears'] ?? 0,
      languages: List<String>.from(map['languages'] ?? []),
      countriesWorked: List<String>.from(map['countriesWorked'] ?? []),
      isAvailable: map['isAvailable'] ?? false,
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      currentCity: map['currentCity'],
      profileImageUrl: map['profileImageUrl'],
      licenseImageUrl: map['licenseImageUrl'],
      attestationUrls: List<String>.from(map['attestationUrls'] ?? []),
      verificationStatus: map['verificationStatus'] ?? 'pending',
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.parse(map['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'driverId': driverId,
      'licenses': licenses,
      'experienceYears': experienceYears,
      'languages': languages,
      'countriesWorked': countriesWorked,
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
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  DriverModel copyWith({
    bool? isAvailable,
    double? latitude,
    double? longitude,
    String? currentCity,
    String? profileImageUrl,
    String? licenseImageUrl,
    List<String>? attestationUrls,
    String? verificationStatus,
  }) {
    return DriverModel(
      id: id,
      driverId: driverId,
      licenses: licenses,
      experienceYears: experienceYears,
      languages: languages,
      countriesWorked: countriesWorked,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      currentCity: currentCity ?? this.currentCity,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      licenseImageUrl: licenseImageUrl ?? this.licenseImageUrl,
      attestationUrls: attestationUrls ?? this.attestationUrls,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}