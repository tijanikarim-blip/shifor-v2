import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/validators.dart';
import '../../services/storage_service.dart';
import '../home/home_screen.dart';

class ProfileCompletionScreen extends StatefulWidget {
  const ProfileCompletionScreen({super.key});

  @override
  State<ProfileCompletionScreen> createState() => _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _licenseController = TextEditingController();
  final _vehicleTypeController = TextEditingController();
  final _plateController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companyDescController = TextEditingController();
  
  File? _profilePhoto;
  File? _licensePhoto;
  File? _logoPhoto;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _licenseController.dispose();
    _vehicleTypeController.dispose();
    _plateController.dispose();
    _companyNameController.dispose();
    _companyDescController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isProfile) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isProfile) {
          _profilePhoto = File(image.path);
        } else if (isProfile == false && isProfile != true) {
          _licensePhoto = File(image.path);
        } else {
          _logoPhoto = File(image.path);
        }
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final storage = StorageService();
      
      String? photoUrl;
      String? licenseUrl;
      String? logoUrl;

      if (_profilePhoto != null) {
        photoUrl = await storage.uploadProfilePhoto(_profilePhoto!, authProvider.user!.uid);
      }
      if (_licensePhoto != null) {
        licenseUrl = await storage.uploadLicensePhoto(_licensePhoto!, authProvider.user!.uid);
      }
      if (_logoPhoto != null) {
        logoUrl = await storage.uploadCompanyLogo(_logoPhoto!, authProvider.user!.uid);
      }

      if (authProvider.isDriver) {
        await authProvider.updateDriverProfile({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
          'licenseNumber': _licenseController.text,
          'vehicleType': _vehicleTypeController.text,
          'vehiclePlate': _plateController.text,
          if (photoUrl != null) 'photoUrl': photoUrl,
          if (licenseUrl != null) 'licensePhotoUrl': licenseUrl,
          'updatedAt': DateTime.now(),
        });
      } else {
        await authProvider.updateCompanyProfile({
          'companyName': _companyNameController.text,
          'description': _companyDescController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
          if (logoUrl != null) 'logoUrl': logoUrl,
          'updatedAt': DateTime.now(),
        });
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isDriver = authProvider.isDriver;

    return Scaffold(
      appBar: AppBar(
        title: Text(isDriver ? 'Complete Driver Profile' : 'Complete Company Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _profilePhoto != null ? FileImage(_profilePhoto!) : null,
                      child: _profilePhoto == null
                          ? const Icon(Icons.person, size: 50, color: Colors.grey)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          onPressed: () => _pickImage(true),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              if (isDriver) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(labelText: 'First Name'),
                        validator: (v) => Validators.required(v, 'First name'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(labelText: 'Last Name'),
                        validator: (v) => Validators.required(v, 'Last name'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone)),
                  validator: Validators.phone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.location_on)),
                  validator: (v) => Validators.required(v, 'Address'),
                ),
                const SizedBox(height: 24),
                const Text('Vehicle Info', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _vehicleTypeController,
                  decoration: const InputDecoration(labelText: 'Vehicle Type', prefixIcon: Icon(Icons.directions_car)),
                  validator: (v) => Validators.required(v, 'Vehicle type'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _plateController,
                  decoration: const InputDecoration(labelText: 'License Plate', prefixIcon: Icon(Icons.credit_card)),
                  validator: (v) => Validators.required(v, 'License plate'),
                ),
                const SizedBox(height: 24),
                const Text('License Photo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _pickImage(false),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _licensePhoto != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_licensePhoto!, fit: BoxFit.cover, width: double.infinity),
                          )
                        : const Center(child: Icon(Icons.add_a_photo, size: 40)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _licenseController,
                  decoration: const InputDecoration(labelText: 'License Number'),
                  validator: (v) => Validators.required(v, 'License number'),
                ),
              ] else ...[
                TextFormField(
                  controller: _companyNameController,
                  decoration: const InputDecoration(labelText: 'Company Name', prefixIcon: Icon(Icons.business)),
                  validator: (v) => Validators.required(v, 'Company name'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone)),
                  validator: Validators.phone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.location_on)),
                  validator: (v) => Validators.required(v, 'Address'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _companyDescController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description', prefixIcon: Icon(Icons.description)),
                ),
                const SizedBox(height: 24),
                const Text('Company Logo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _pickImage(true),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _logoPhoto != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_logoPhoto!, fit: BoxFit.cover, width: double.infinity),
                          )
                        : const Center(child: Icon(Icons.add_a_photo, size: 40)),
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}