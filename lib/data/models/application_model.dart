class ApplicationModel {
  final String id;
  final String jobId;
  final String driverId;
  final String driverName;
  final String driverPhotoUrl;
  final String status;
  final String? coverLetter;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ApplicationModel({
    required this.id,
    required this.jobId,
    required this.driverId,
    required this.driverName,
    this.driverPhotoUrl = '',
    this.status = 'pending',
    this.coverLetter,
    required this.createdAt,
    this.updatedAt,
  });

  factory ApplicationModel.fromMap(Map<String, dynamic> map, String id) {
    return ApplicationModel(
      id: id,
      jobId: map['jobId'] ?? '',
      driverId: map['driverId'] ?? '',
      driverName: map['driverName'] ?? '',
      driverPhotoUrl: map['driverPhotoUrl'] ?? '',
      status: map['status'] ?? 'pending',
      coverLetter: map['coverLetter'],
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
      'jobId': jobId,
      'driverId': driverId,
      'driverName': driverName,
      'driverPhotoUrl': driverPhotoUrl,
      'status': status,
      'coverLetter': coverLetter,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}