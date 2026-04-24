import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String id;
  final String companyId;
  final String companyName;
  final String? companyLogoUrl;
  final String title;
  final String? description;
  final String jobType;
  final String? location;
  final double? latitude;
  final double? longitude;
  final double? salary;
  final String salaryType;
  final List<String> requirements;
  final List<String> benefits;
  final DateTime startDate;
  final DateTime? endDate;
  final int maxApplications;
  final int currentApplications;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  JobModel({
    required this.id,
    required this.companyId,
    required this.companyName,
    this.companyLogoUrl,
    required this.title,
    this.description,
    required this.jobType,
    this.location,
    this.latitude,
    this.longitude,
    this.salary,
    this.salaryType = 'monthly',
    this.requirements = const [],
    this.benefits = const [],
    required this.startDate,
    this.endDate,
    this.maxApplications = 10,
    this.currentApplications = 0,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory JobModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JobModel(
      id: doc.id,
      companyId: data['companyId'] ?? '',
      companyName: data['companyName'] ?? '',
      companyLogoUrl: data['companyLogoUrl'],
      title: data['title'] ?? '',
      description: data['description'],
      jobType: data['jobType'] ?? '',
      location: data['location'],
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      salary: (data['salary'] as num?)?.toDouble(),
      salaryType: data['salaryType'] ?? 'monthly',
      requirements: List<String>.from(data['requirements'] ?? []),
      benefits: List<String>.from(data['benefits'] ?? []),
      startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as Timestamp?)?.toDate(),
      maxApplications: data['maxApplications'] ?? 10,
      currentApplications: data['currentApplications'] ?? 0,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'companyId': companyId,
      'companyName': companyName,
      'companyLogoUrl': companyLogoUrl,
      'title': title,
      'description': description,
      'jobType': jobType,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'salary': salary,
      'salaryType': salaryType,
      'requirements': requirements,
      'benefits': benefits,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'maxApplications': maxApplications,
      'currentApplications': currentApplications,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  JobModel copyWith({
    String? id,
    String? companyId,
    String? companyName,
    String? companyLogoUrl,
    String? title,
    String? description,
    String? jobType,
    String? location,
    double? latitude,
    double? longitude,
    double? salary,
    String? salaryType,
    List<String>? requirements,
    List<String>? benefits,
    DateTime? startDate,
    DateTime? endDate,
    int? maxApplications,
    int? currentApplications,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JobModel(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      companyLogoUrl: companyLogoUrl ?? this.companyLogoUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      jobType: jobType ?? this.jobType,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      salary: salary ?? this.salary,
      salaryType: salaryType ?? this.salaryType,
      requirements: requirements ?? this.requirements,
      benefits: benefits ?? this.benefits,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      maxApplications: maxApplications ?? this.maxApplications,
      currentApplications: currentApplications ?? this.currentApplications,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}