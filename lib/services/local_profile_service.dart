import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class LocalProfile {
  static Map<String, dynamic>? _profile;
  
  static Future<Map<String, dynamic>> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _profile ?? {
      'name': '',
      'email': '',
      'phone': '',
      'role': '',
      'photoPath': '',
      'licensePath': '',
      'experience': '',
      'country': '',
    };
  }
  
  static Future<void> updateProfile(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _profile = {...?_profile, ...data};
  }
  
  static Future<void> updatePhoto(String path) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _profile = {...?_profile, 'photoPath': path};
  }
  
  static Future<void> updateLicense(String path) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _profile = {...?_profile, 'licensePath': path};
  }
}