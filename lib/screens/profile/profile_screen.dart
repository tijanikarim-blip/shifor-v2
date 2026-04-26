import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../services/local_profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _experienceController = TextEditingController();
  final _countryController = TextEditingController();
  String? _photoPath;
  String? _licensePath;
  bool _isLoading = false;
  String _role = 'driver';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _experienceController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final profile = await LocalProfile.getProfile();
    if (profile != null && profile.isNotEmpty) {
      setState(() {
        _nameController.text = profile['name'] ?? '';
        _phoneController.text = profile['phone'] ?? '';
        _experienceController.text = profile['experience'] ?? '';
        _countryController.text = profile['country'] ?? '';
        _photoPath = profile['photoPath'];
        _licensePath = profile['licensePath'];
        _role = profile['role'] ?? 'driver';
      });
    }
  }

  Future<void> _pickImage(String type) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (image != null) {
      setState(() {
        if (type == 'photo') {
          _photoPath = image.path;
        } else {
          _licensePath = image.path;
        }
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    
    await LocalProfile.updateProfile({
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'experience': _experienceController.text.trim(),
      'country': _countryController.text.trim(),
      'role': _role,
    });
    
    if (_photoPath != null) {
      await LocalProfile.updatePhoto(_photoPath!);
    }
    if (_licensePath != null) {
      await LocalProfile.updateLicense(_licensePath!);
    }
    
    setState(() => _isLoading = false);
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved!'), backgroundColor: AppColors.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Column(children: [
              GestureDetector(
                onTap: () => _pickImage('photo'),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  backgroundImage: _photoPath != null ? AssetImage(_photoPath!) : null,
                  child: _photoPath == null ? const Icon(Icons.camera_alt, size: 30, color: Colors.white) : null,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _pickImage('photo'),
                child: const Text('Tap to add photo', style: TextStyle(color: AppColors.primary, fontSize: 12)),
              ),
            ])),
            const SizedBox(height: 24),
            const Text('Personal Info', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outlined))),
            const SizedBox(height: 16),
            TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined))),
            const SizedBox(height: 16),
            TextField(controller: _experienceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Years of Experience', prefixIcon: Icon(Icons.work_outlined))),
            const SizedBox(height: 16),
            TextField(controller: _countryController, decoration: const InputDecoration(labelText: 'Country', prefixIcon: Icon(Icons.location_on_outlined))),
            const SizedBox(height: 32),
            const Text('Documents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _pickImage('license'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(children: [
                  Icon(_licensePath != null ? Icons.check_circle : Icons.badge_outlined, color: _licensePath != null ? AppColors.success : AppColors.textSecondary),
                  const SizedBox(width: 16),
                  Expanded(child: Text(_licensePath != null ? 'License uploaded' : 'Upload Driver License', style: TextStyle(color: _licensePath != null ? AppColors.success : AppColors.textPrimary))),
                  const Icon(Icons.upload_outlined, color: AppColors.textSecondary),
                ]),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveProfile,
              child: _isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Save Profile')
            ),
            const SizedBox(height: 32),
            const Divider(),
            _MenuItem(Icons.logout, 'Logout', () {
              Navigator.of(context).pushNamedAndRemoveUntil('/sign-in', (route) => false);
            }, isDestructive: true),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;
  const _MenuItem(this.icon, this.title, this.onTap, {this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Row(children: [
        Icon(icon, color: isDestructive ? AppColors.error : AppColors.textSecondary),
        const SizedBox(width: 16),
        Expanded(child: Text(title, style: TextStyle(fontSize: 16, color: isDestructive ? AppColors.error : AppColors.textPrimary))),
        Icon(Icons.chevron_right, color: Colors.grey[400]),
      ])),
    );
  }
}