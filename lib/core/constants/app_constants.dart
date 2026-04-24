class AppConstants {
  static const appName = 'Shifor';
  static const appTagline = 'Driver Recruitment Platform';
  
  // Firestore Collections
  static const usersCollection = 'users';
  static const driversCollection = 'drivers';
  static const companiesCollection = 'companies';
  static const jobsCollection = 'jobs';
  static const applicationsCollection = 'applications';
  static const messagesCollection = 'messages';
  
  // Storage Buckets
  static const profilesBucket = 'profiles';
  static const licensesBucket = 'licenses';
  static const attestationsBucket = 'attestations';
  static const logosBucket = 'logos';
  
  // Roles
  static const roleDriver = 'driver';
  static const roleCompany = 'company';
  static const roleAgency = 'agency';
  
  // License Types
  static const licenseTypes = ['B', 'C', 'D', 'CE', 'C1', 'C1E'];
  
  // Languages
  static const languages = ['English', 'French', 'Arabic', 'Spanish', 'German', 'Portuguese', 'Italian'];
  
  // Countries
  static const countries = [
    'Morocco', 'France', 'Spain', 'Germany', 'Italy', 'UK', 'USA', 'Canada',
    'UAE', 'Saudi Arabia', 'Qatar', 'Kuwait', 'Bahrain', 'Oman',
  ];
  
  // Vehicle Types
  static const vehicleTypes = [
    'Light Vehicle (B)',
    'Small Bus (D1)',
    'Bus (D)',
    'Truck (C)',
    'Heavy Truck (CE)',
  ];
  
  // Contract Durations
  static const contractDurations = [
    '3 months',
    '6 months',
    '1 year',
    '2 years',
    'Permanent',
  ];
  
  // Application Status
  static const statusPending = 'pending';
  static const statusAccepted = 'accepted';
  static const statusRejected = 'rejected';
  static const statusWithdrawn = 'withdrawn';
  
  // Verification Status
  static const verificationPending = 'pending';
  static const verificationVerified = 'verified';
  static const verificationRejected = 'rejected';
}