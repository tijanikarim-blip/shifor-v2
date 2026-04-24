import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        return getUserData(credential.user!.uid);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<UserModel?> signUpWithEmail(String email, String password, String role) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await credential.user!.sendEmailVerification();
        await createUserInFirestore(
          credential.user!.uid,
          email,
          role,
        );
        return getUserData(credential.user!.uid);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<String> signInWithPhone(String phone) async {
    final confirmationResult = await _auth.signInWithPhoneNumber(phone);
    return '';
  }

  Future<UserCredential?> verifyOTP(String verificationId, String otp) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        code: otp,
      );
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> createUserInFirestore(String uid, String email, String role) async {
    await _firestore.collection(AppConstants.usersCollection).doc(uid).set({
      'email': email,
      'role': role,
      'emailVerified': false,
      'isActive': true,
      'createdAt': Timestamp.fromDate(DateTime.now()),
    });

    if (role == AppConstants.roleDriver) {
      await _firestore.collection(AppConstants.driversCollection).doc(uid).set({
        'userId': uid,
        'isAvailable': false,
        'isVerified': false,
        'isOnline': false,
        'rating': 0,
        'totalJobs': 0,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });
    } else if (role == AppConstants.roleCompany || role == AppConstants.roleAgency) {
      await _firestore.collection(AppConstants.companiesCollection).doc(uid).set({
        'userId': uid,
        'isVerified': false,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    data['updatedAt'] = Timestamp.fromDate(DateTime.now());
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .update(data);
  }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak';
      case 'user-disabled':
        return 'This account has been disabled';
      default:
        return e.message ?? 'Authentication failed';
    }
  }
}