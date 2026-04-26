import 'package:flutter/material.dart';

class LocalAuth {
  static final Map<String, Map<String, String>> _users = {};
  
  static Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (_users.containsKey(email.toLowerCase())) {
      return false;
    }
    
    _users[email.toLowerCase()] = {
      'name': name,
      'email': email.toLowerCase(),
      'password': password,
      'phone': phone,
      'role': role,
    };
    
    return true;
  }
  
  static Future<Map<String, String>?> signIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final user = _users[email.toLowerCase()];
    if (user == null || user['password'] != password) {
      return null;
    }
    
    return user;
  }
  
  static bool userExists(String email) {
    return _users.containsKey(email.toLowerCase());
  }
}