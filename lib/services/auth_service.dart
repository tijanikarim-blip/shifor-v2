import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();

  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return await _userRepository.getUser(firebaseUser.uid);
    });
  }

  UserModel? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? '',
      phone: firebaseUser.phoneNumber ?? '',
      role: '',
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }

  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  Future<AuthResult<UserModel>> signIn(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password,
      );
      
      if (credential.user == null) {
        return AuthResult.failure('Sign in failed');
      }
      
      final user = await _userRepository.getUser(credential.user!.uid);
      if (user == null) {
        await _firebaseAuth.signOut();
        return AuthResult.failure('User data not found');
      }
      
      return AuthResult.success(user);
    } on auth.FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e.code));
    } catch (e) {
      return AuthResult.failure('Sign in failed. Please try again.');
    }
  }

  Future<AuthResult<UserModel>> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
  }) async {
    try {
      final existingUser = await _userRepository.emailExists(email);
      if (existingUser) {
        return AuthResult.failure('Email already in use');
      }
      
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password,
      );
      
      if (credential.user == null) {
        return AuthResult.failure('Sign up failed');
      }
      
      await credential.user!.updateProfile(displayName: name);
      await credential.user!.sendEmailVerification();
      
      final userData = {
        'name': name.trim(),
        'email': email.toLowerCase().trim(),
        'phone': phone.trim(),
        'role': role,
        'isVerified': false,
        'isEmailVerified': false,
        'isPhoneVerified': false,
        'profileCompleted': false,
        'createdAt': DateTime.now().toIso8601String(),
      };
      
      await _userRepository.createUser(credential.user!.uid, userData);
      
      final user = await _userRepository.getUser(credential.user!.uid);
      return AuthResult.success(user!);
    } on auth.FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e.code));
    } catch (e) {
      return AuthResult.failure('Sign up failed. Please try again.');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'Email already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      default:
        return 'An error occurred';
    }
  }
}

class AuthResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  AuthResult._({this.data, this.error, required this.isSuccess});

  factory AuthResult.success(T data) => AuthResult._(data: data, isSuccess: true);
  factory AuthResult.failure(String error) => AuthResult._(error: error, isSuccess: false);
}