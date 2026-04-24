import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../services/location_service.dart';
import '../../services/storage_service.dart';
import '../../data/repositories/user_repository.dart';

class ProfileCompletionScreen extends StatefulWidget {
  const ProfileCompletionScreen({super.key});

  @override
  State<ProfileCompletionScreen> createState() => _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _expController = TextEditingController();
  
  final _imagePicker = ImagePicker();
  final _locationService = LocationService();
  final _storageService = StorageService();
  final _userRepo = UserRepository();
  
  String? _profileImagePath;
  String? _licenseImagePath;
  final List<String> _selectedLicenses = [];
  final List<String> _selectedLanguages = [];
  String? _currentCity;
  double _progress = 0;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _expController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    double progress = 0;
    if (_nameController.text.isNotEmpty) progress += 20;
    if (_selectedLicenses.isNotEmpty) progress += 20;
    if (_selectedLanguages.isNotEmpty) progress += 20;
    if (_profileImagePath != null) progress += 20;
    if (_licenseImagePath != null) progress += 20;
    setState(() => _progress = progress);
  }

  Future<File?> _pickProfileImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 800, maxHeight: 800);
    if (pickedFile != null) {
      setState(() => _profileImagePath = pickedFile.path);
      _updateProgress();
    }
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<File?> _pickLicenseImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (pickedFile != null) {
      setState(() => _licenseImagePath = pickedFile.path);
      _updateProgress();
    }
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<void> _getLocation() async {
    setState(() => _isLoading = true);
    
    final result = await _locationService.getCurrentLocation();
    if (result.isSuccess && result.data != null) {
      final city = await _locationService.getCityFromCoordinates(
        result.data!.latitude,
        result.data!.longitude,
      );
      setState(() {
        _currentCity = city ?? 'Unknown';
      });
    } else {
      setState(() => _currentCity = 'Casablanca, Morocco');
    }
    setState(() => _isLoading = false);
    _updateProgress();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_profileImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a profile picture')),
      );
      return;
    }
    if (_selectedLicenses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one license type')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = context.read<AuthProvider>().user?.id;
      if (userId == null) return;

      String? profileUrl;
      String? licenseUrl;

      if (_profileImagePath != null) {
        profileUrl = await _storageService.uploadProfileImage(userId, File(_profileImagePath!));
      }
      if (_licenseImagePath != null) {
        licenseUrl = await _storageService.uploadLicenseImage(userId, File(_licenseImagePath!));
      }

      final locResult = await _locationService.getCurrentLocation();
      double? lat;
      double? lng;
      if (locResult.isSuccess && locResult.data != null) {
        lat = locResult.data!.latitude;
        lng = locResult.data!.longitude;
        _currentCity ??= await _locationService.getCityFromCoordinates(lat, lng);
      }

      final driverData = {
        'driverId': userId,
        'name': _nameController.text.trim(),
        'licenses': _selectedLicenses,
        'experienceYears': int.tryParse(_expController.text) ?? 0,
        'languages': _selectedLanguages,
        'isAvailable': false,
        'latitude': lat,
        'longitude': lng,
        'currentCity': _currentCity ?? 'Not set',
        'profileImageUrl': profileUrl,
        'licenseImageUrl': licenseUrl,
        'attestationUrls': [],
        'verificationStatus': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _userRepo.createDriverProfile(userId, driverData);
      await _userRepo.updateUser(userId, {'profileCompleted': true});

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ProgressBar(progress: _progress),
              const SizedBox(height: 24),
              
              // Profile Image
              _buildProfileImageSection(),
              const SizedBox(height: 24),
              
              // Name
              TextFormField(
                controller: _nameController,
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
                onChanged: (_) => _updateProgress(),
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              
              // Experience
              TextFormField(
                controller: _expController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Years of Experience',
                  prefixIcon: Icon(Icons.work),
                ),
              ),
              const SizedBox(height: 24),
              
              // License
              _buildLicenseSection(),
              const SizedBox(height: 24),
              
              // Languages
              _buildLanguagesSection(),
              const SizedBox(height: 24),
              
              // Location
              _buildLocationSection(),
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                child: _isLoading
                    ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                    : const Text('Complete Profile'),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Profile Picture *', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickProfileImage,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              image: _profileImagePath != null
                  ? DecorationImage(image: FileImage(File(_profileImagePath!)), fit: BoxFit.cover)
                  : null,
            ),
            child: _profileImagePath == null
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Tap to upload'),
                      ],
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildLicenseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Driver License *', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickLicenseImage,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: _licenseImagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.file(File(_licenseImagePath!), fit: BoxFit.cover),
                  )
                : const Center(
                    child: Text('Upload License Image', style: TextStyle(color: Colors.grey)),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.licenseTypes.map((license) {
            final isSelected = _selectedLicenses.contains(license);
            return FilterChip(
              label: Text(license),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selected ? _selectedLicenses.add(license) : _selectedLicenses.remove(license);
                });
                _updateProgress();
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLanguagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Languages', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.languages.map((lang) {
            final isSelected = _selectedLanguages.contains(lang);
            return FilterChip(
              label: Text(lang),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selected ? _selectedLanguages.add(lang) : _selectedLanguages.remove(lang);
                });
                _updateProgress();
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Location', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _currentCity == null ? _getLocation : null,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _currentCity != null ? Colors.green : Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(
                  _currentCity != null ? Icons.location_on : Icons.location_searching,
                  color: _currentCity != null ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _currentCity ?? 'Tap to detect location',
                    style: TextStyle(
                      color: _currentCity != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                if (_isLoading) const CircularProgressIndicator(strokeWidth: 2),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Profile Completion', style: TextStyle(fontWeight: FontWeight.w600)),
            Text(
              '${progress.toInt()}%',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress / 100,
            minHeight: 10,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }
}