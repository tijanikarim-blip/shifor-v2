class CompanyModel {
  final String id;
  final String companyId;
  final String companyName;
  final String country;
  final String? logoUrl;
  final String? documentUrl;
  final bool verified;
  final double rating;
  final String verificationStatus;
  final DateTime createdAt;

  CompanyModel({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.country,
    this.logoUrl,
    this.documentUrl,
    this.verified = false,
    this.rating = 0,
    this.verificationStatus = 'pending',
    required this.createdAt,
  });

  factory CompanyModel.fromMap(Map<String, dynamic> map, String id) {
    return CompanyModel(
      id: id,
      companyId: map['companyId'] ?? '',
      companyName: map['companyName'] ?? '',
      country: map['country'] ?? '',
      logoUrl: map['logoUrl'],
      documentUrl: map['documentUrl'],
      verified: map['verified'] ?? false,
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      verificationStatus: map['verificationStatus'] ?? 'pending',
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'companyName': companyName,
      'country': country,
      'logoUrl': logoUrl,
      'documentUrl': documentUrl,
      'verified': verified,
      'rating': rating,
      'verificationStatus': verificationStatus,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}