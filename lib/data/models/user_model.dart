class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final bool isVerified;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool profileCompleted;
  final DateTime createdAt;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.isVerified = false,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.profileCompleted = false,
    required this.createdAt,
    this.profileImageUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? '',
      isVerified: map['isVerified'] ?? false,
      isEmailVerified: map['isEmailVerified'] ?? false,
      isPhoneVerified: map['isPhoneVerified'] ?? false,
      profileCompleted: map['profileCompleted'] ?? false,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      profileImageUrl: map['profileImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'isVerified': isVerified,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'profileCompleted': profileCompleted,
      'createdAt': createdAt.toIso8601String(),
      'profileImageUrl': profileImageUrl,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
    bool? isVerified,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? profileCompleted,
    String? profileImageUrl,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      createdAt: createdAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  bool get isFullyVerified => isEmailVerified && isPhoneVerified;
  bool get isDriver => role == 'driver';
  bool get isCompany => role == 'company';
}