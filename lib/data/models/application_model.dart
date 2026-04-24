import 'package:cloud_firestore/cloud_firestore.dart';

enum ApplicationStatus { pending, accepted, rejected, cancelled }

class ApplicationModel {
  final String id;
  final String jobId;
  final String driverId;
  final String companyId;
  final String? driverName;
  final String? driverPhotoUrl;
  final String? jobTitle;
  final String? companyName;
  final String? message;
  final String status;
  final DateTime appliedAt;
  final DateTime? reviewedAt;
  final DateTime? updatedAt;

  ApplicationModel({
    required this.id,
    required this.jobId,
    required this.driverId,
    required this.companyId,
    this.driverName,
    this.driverPhotoUrl,
    this.jobTitle,
    this.companyName,
    this.message,
    this.status = 'pending',
    required this.appliedAt,
    this.reviewedAt,
    this.updatedAt,
  });

  factory ApplicationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ApplicationModel(
      id: doc.id,
      jobId: data['jobId'] ?? '',
      driverId: data['driverId'] ?? '',
      companyId: data['companyId'] ?? '',
      driverName: data['driverName'],
      driverPhotoUrl: data['driverPhotoUrl'],
      jobTitle: data['jobTitle'],
      companyName: data['companyName'],
      message: data['message'],
      status: data['status'] ?? 'pending',
      appliedAt: (data['appliedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reviewedAt: (data['reviewedAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'jobId': jobId,
      'driverId': driverId,
      'companyId': companyId,
      'driverName': driverName,
      'driverPhotoUrl': driverPhotoUrl,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'message': message,
      'status': status,
      'appliedAt': Timestamp.fromDate(appliedAt),
      'reviewedAt': reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  ApplicationModel copyWith({
    String? id,
    String? jobId,
    String? driverId,
    String? companyId,
    String? driverName,
    String? driverPhotoUrl,
    String? jobTitle,
    String? companyName,
    String? message,
    String? status,
    DateTime? appliedAt,
    DateTime? reviewedAt,
    DateTime? updatedAt,
  }) {
    return ApplicationModel(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      driverId: driverId ?? this.driverId,
      companyId: companyId ?? this.companyId,
      driverName: driverName ?? this.driverName,
      driverPhotoUrl: driverPhotoUrl ?? this.driverPhotoUrl,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      message: message ?? this.message,
      status: status ?? this.status,
      appliedAt: appliedAt ?? this.appliedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
}