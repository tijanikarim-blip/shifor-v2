import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage(String userId, File file) async {
    final ref = _storage.ref().child('profiles').child('$userId.jpg');
    await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
    return await ref.getDownloadURL();
  }

  Future<String> uploadLicenseImage(String userId, File file) async {
    final ref = _storage.ref().child('licenses').child('$userId.jpg');
    await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
    return await ref.getDownloadURL();
  }

  Future<String> uploadAttestation(String userId, int index, File file) async {
    final ext = file.path.split('.').last;
    final ref = _storage.ref().child('attestations').child('${userId}_$index.$ext');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<String> uploadCompanyLogo(String userId, File file) async {
    final ref = _storage.ref().child('logos').child('$userId.jpg');
    await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
    return await ref.getDownloadURL();
  }

  Future<void> deleteFile(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (_) {}
  }

  Future<void> deleteProfileImage(String userId) async {
    try {
      await _storage.ref().child('profiles').child('$userId.jpg').delete();
    } catch (_) {}
  }

  Future<void> deleteLicenseImage(String userId) async {
    try {
      await _storage.ref().child('licenses').child('$userId.jpg').delete();
    } catch (_) {}
  }
}