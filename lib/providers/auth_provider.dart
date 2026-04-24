import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../services/auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _user;
  AuthStatus _status = AuthStatus.unknown;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  AuthStatus get status => _status;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _checkAuthState();
  }

  void _checkAuthState() {
    _authService.authStateChanges.listen((UserModel? user) {
      _user = user;
      if (user != null) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _error = null;
    
    final result = await _authService.signIn(email, password);
    
    if (result.isSuccess) {
      _user = result.data;
      _status = AuthStatus.authenticated;
    } else {
      _error = result.error;
    }
    
    _setLoading(false);
    return result.isSuccess;
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
  }) async {
    _setLoading(true);
    _error = null;
    
    final result = await _authService.signUp(
      email: email,
      password: password,
      name: name,
      phone: phone,
      role: role,
    );
    
    if (result.isSuccess) {
      _user = result.data;
      _status = AuthStatus.authenticated;
    } else {
      _error = result.error;
    }
    
    _setLoading(false);
    return result.isSuccess;
  }

  Future<void> signOut() async {
    _setLoading(true);
    await _authService.signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    _setLoading(false);
  }

  Future<void> sendVerificationEmail() async {
    await _authService.sendEmailVerification();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}