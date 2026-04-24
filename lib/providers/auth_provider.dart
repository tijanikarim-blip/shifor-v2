import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/driver_model.dart';
import '../../data/models/company_model.dart';
import '../../core/constants/app_constants.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  UserModel? _userModel;
  DriverModel? _driverModel;
  CompanyModel? _companyModel;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  DriverModel? get driverModel => _driverModel;
  CompanyModel? get companyModel => _companyModel;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isDriver => _userModel?.role == AppConstants.roleDriver;
  bool get isCompany => _userModel?.role == AppConstants.roleCompany || _userModel?.role == AppConstants.roleAgency;
  bool get isEmailVerified => _user?.emailVerified ?? false;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _user = _authService.currentUser;
    if (_user != null) {
      await loadUserData();
    }
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _userModel = await _authService.signInWithEmail(email, password);
      _user = _authService.currentUser;
      if (_userModel != null) {
        await loadProfileData();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String role) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _userModel = await _authService.signUpWithEmail(email, password, role);
      _user = _authService.currentUser;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await _authService.signOut();
    _user = null;
    _userModel = null;
    _driverModel = null;
    _companyModel = null;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadUserData() async {
    if (_user == null) return;
    _userModel = await _authService.getUserData(_user!.uid);
    await loadProfileData();
    notifyListeners();
  }

  Future<void> loadProfileData() async {
    if (_userModel == null) return;
    
    if (_userModel!.role == AppConstants.roleDriver) {
      final doc = await FirebaseFirestore.instance
          .collection(AppConstants.driversCollection)
          .doc(_user!.uid)
          .get();
      if (doc.exists) {
        _driverModel = DriverModel.fromFirestore(doc);
      }
    } else {
      final doc = await FirebaseFirestore.instance
          .collection(AppConstants.companiesCollection)
          .doc(_user!.uid)
          .get();
      if (doc.exists) {
        _companyModel = CompanyModel.fromFirestore(doc);
      }
    }
    notifyListeners();
  }

  Future<void> updateDriverProfile(Map<String, dynamic> data) async {
    if (_user == null) return;
    await FirebaseFirestore.instance
        .collection(AppConstants.driversCollection)
        .doc(_user!.uid)
        .update(data);
    await loadProfileData();
  }

  Future<void> updateCompanyProfile(Map<String, dynamic> data) async {
    if (_user == null) return;
    await FirebaseFirestore.instance
        .collection(AppConstants.companiesCollection)
        .doc(_user!.uid)
        .update(data);
    await loadProfileData();
  }

  void toggleAvailability() async {
    if (_driverModel == null) return;
    await updateDriverProfile({'isAvailable': !_driverModel!.isAvailable});
  }

  Future<void> sendVerificationEmail() async {
    await _user?.sendEmailVerification();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}