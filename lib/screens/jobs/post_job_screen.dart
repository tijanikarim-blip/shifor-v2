import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../data/repositories/job_repository.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _salaryController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCountry = '';
  String _selectedVehicle = '';
  String _selectedDuration = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _salaryController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _postJob() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCountry.isEmpty || _selectedVehicle.isEmpty || _selectedDuration.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    if (user == null || user.role != AppConstants.roleCompany) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Only companies can post jobs')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final jobRepo = context.read<JobRepository>();
      await jobRepo.createJob({
        'title': _titleController.text.trim(),
        'companyId': user.id,
        'companyName': user.name,
        'country': _selectedCountry,
        'salary': double.tryParse(_salaryController.text) ?? 0,
        'vehicleType': _selectedVehicle,
        'contractDuration': _selectedDuration,
        'description': _descController.text.trim(),
        'isActive': true,
        'createdAt': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job posted successfully!'), backgroundColor: AppColors.success));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Job')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text('Job Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(controller: _titleController, validator: (v) => v?.isEmpty == true ? 'Required' : null, decoration: const InputDecoration(labelText: 'Job Title', prefixIcon: Icon(Icons.work))),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: _selectedCountry.isEmpty ? null : _selectedCountry,
              decoration: const InputDecoration(labelText: 'Country', prefixIcon: Icon(Icons.location_on)),
              items: AppConstants.countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCountry = v ?? ''),
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(controller: _salaryController, keyboardType: TextInputType.number, validator: (v) => v?.isEmpty == true ? 'Required' : null, decoration: const InputDecoration(labelText: 'Monthly Salary (\$)', prefixIcon: Icon(Icons.monetization_on))),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: _selectedVehicle.isEmpty ? null : _selectedVehicle,
              decoration: const InputDecoration(labelText: 'Vehicle Type', prefixIcon: Icon(Icons.directions_car)),
              items: AppConstants.vehicleTypes.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (v) => setState(() => _selectedVehicle = v ?? ''),
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: _selectedDuration.isEmpty ? null : _selectedDuration,
              decoration: const InputDecoration(labelText: 'Contract Duration', prefixIcon: Icon(Icons.schedule)),
              items: AppConstants.contractDurations.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (v) => setState(() => _selectedDuration = v ?? ''),
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(controller: _descController, maxLines: 4, decoration: const InputDecoration(labelText: 'Description', alignLabelWithHint: true)),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: _isLoading ? null : _postJob, child: _isLoading ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white) : const Text('Post Job')),
          ]),
        ),
      ),
    );
  }
}