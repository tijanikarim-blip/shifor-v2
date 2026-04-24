import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyModel {
  final String id;
  final String userId;
  final String companyName;
  final String? description;
  final String? logoUrl;
  final String? address;
  final String? phone;
  final String? website;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CompanyModel({
    required this.id,
    required this.userId,
    required this.companyName,
    this.description,
    this.logoUrl,
    this.address,
    this.phone,
    this.website,
    this.isVerified = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory CompanyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CompanyModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      companyName: data['companyName'] ?? '',
      description: data['description'],
      logoUrl: data['logoUrl'],
      address: data['address'],
      phone: data['phone'],
      website: data['website'],
      isVerified: data['isVerified'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'companyName': companyName,
      'description': description,
      'logoUrl': logoUrl,
      'address': address,
      'phone': phone,
      'website': website,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  CompanyModel copyWith({
    String? id,
    String? userId,
    String? companyName,
    String? description,
    String? logoUrl,
    String? address,
    String? phone,
    String? website,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      companyName: companyName ?? this.companyName,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}