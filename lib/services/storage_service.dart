import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      return await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
    } catch (e) {
      return null;
    }
  }

  Future<String?> uploadFile(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final task = ref.putFile(
        file,
        SettableMetadata(
          contentType: 'image/jpeg',
        ),
      );
      final snapshot = await task;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<String?> uploadProfilePhoto(File file, String userId) async {
    final path = 'profiles/$userId/profile_photo.jpg';
    return await uploadFile(file, path);
  }

  Future<String?> uploadLicensePhoto(File file, String userId) async {
    final path = 'licenses/$userId/license_photo.jpg';
    return await uploadFile(file, path);
  }

  Future<String?> uploadCompanyLogo(File file, String companyId) async {
    final path = 'companies/$companyId/logo.jpg';
    return await uploadFile(file, path);
  }

  Future<String?> uploadJobPhoto(File file, String jobId) async {
    final path = 'jobs/$jobId/photo.jpg';
    return await uploadFile(file, path);
  }

  Future<bool> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> uploadMultipleImages(
    List<File> files,
    String folder,
    String id,
  ) async {
    final urls = <String>[];
    for (var i = 0; i < files.length; i++) {
      final path = '$folder/$id/image_$i.jpg';
      final url = await uploadFile(files[i], path);
      if (url != null) {
        urls.add(url);
      }
    }
    return urls;
  }
}