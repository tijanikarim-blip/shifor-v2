class JobModel {
  final String id;
  final String companyId;
  final String companyName;
  final String? companyLogoUrl;
  final String title;
  final String country;
  final double salary;
  final String vehicleType;
  final String contractDuration;
  final bool visaSponsorship;
  final String? description;
  final List<String> requirements;
  final bool isActive;
  final DateTime createdAt;

  JobModel({
    required this.id,
    required this.companyId,
    required this.companyName,
    this.companyLogoUrl,
    required this.title,
    required this.country,
    required this.salary,
    required this.vehicleType,
    required this.contractDuration,
    this.visaSponsorship = false,
    this.description,
    this.requirements = const [],
    this.isActive = true,
    required this.createdAt,
  });

  factory JobModel.fromMap(Map<String, dynamic> map, String id) {
    return JobModel(
      id: id,
      companyId: map['companyId'] ?? '',
      companyName: map['companyName'] ?? '',
      companyLogoUrl: map['companyLogoUrl'],
      title: map['title'] ?? '',
      country: map['country'] ?? '',
      salary: (map['salary'] as num?)?.toDouble() ?? 0,
      vehicleType: map['vehicleType'] ?? '',
      contractDuration: map['contractDuration'] ?? '',
      visaSponsorship: map['visaSponsorship'] ?? false,
      description: map['description'],
      requirements: List<String>.from(map['requirements'] ?? []),
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'companyName': companyName,
      'companyLogoUrl': companyLogoUrl,
      'title': title,
      'country': country,
      'salary': salary,
      'vehicleType': vehicleType,
      'contractDuration': contractDuration,
      'visaSponsorship': visaSponsorship,
      'description': description,
      'requirements': requirements,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  JobModel copyWith({
    bool? isActive,
  }) {
    return JobModel(
      id: id,
      companyId: companyId,
      companyName: companyName,
      companyLogoUrl: companyLogoUrl,
      title: title,
      country: country,
      salary: salary,
      vehicleType: vehicleType,
      contractDuration: contractDuration,
      visaSponsorship: visaSponsorship,
      description: description,
      requirements: requirements,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }
}