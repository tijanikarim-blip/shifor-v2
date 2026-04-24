import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/job_model.dart';
import '../../data/repositories/job_repository.dart';
import '../../providers/auth_provider.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _benefitsController = TextEditingController();
  
  String _jobType = 'Full Time';
  String _salaryType = 'monthly';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _salaryController.dispose();
    _requirementsController.dispose();
    _benefitsController.dispose();
    super.dispose();
  }

  Future<void> _postJob() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final company = authProvider.companyModel;

      if (company == null) return;

      final job = JobModel(
        id: '',
        companyId: authProvider.user!.uid,
        companyName: company.companyName,
        companyLogoUrl: company.logoUrl,
        title: _titleController.text,
        description: _descController.text,
        jobType: _jobType.toLowerCase().replaceAll(' ', '_'),
        location: _locationController.text,
        salary: double.tryParse(_salaryController.text),
        salaryType: _salaryType,
        requirements: _requirementsController.text.isNotEmpty
            ? _requirementsController.text.split(',')
            : [],
        benefits: _benefitsController.text.isNotEmpty
            ? _benefitsController.text.split(',')
            : [],
        startDate: DateTime.now(),
        createdAt: DateTime.now(),
      );

      await JobRepository().createJob(job);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job posted successfully')),
        );
        Navigator.pop(context);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Job'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Job Title',
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (v) => v?.isEmpty == true ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _jobType,
                decoration: const InputDecoration(
                  labelText: 'Job Type',
                  prefixIcon: Icon(Icons.category),
                ),
                items: ['Full Time', 'Part Time', 'Contract', 'Internship']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) => setState(() => _jobType = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                validator: (v) => v?.isEmpty == true ? 'Description is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (v) => v?.isEmpty == true ? 'Location is required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _salaryController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Salary',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (v) => v?.isEmpty == true ? 'Salary is required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _salaryType,
                      decoration: const InputDecoration(labelText: 'Type'),
                      items: ['hourly', 'monthly', 'yearly']
                          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      onChanged: (value) => setState(() => _salaryType = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _requirementsController,
                decoration: const InputDecoration(
                  labelText: 'Requirements (comma separated)',
                  prefixIcon: Icon(Icons.check_circle),
                  hintText: 'e.g., Valid license, 2 years experience',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _benefitsController,
                decoration: const InputDecoration(
                  labelText: 'Benefits (comma separated)',
                  prefixIcon: Icon(Icons.star),
                  hintText: 'e.g., Health insurance, Paid vacation',
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _postJob,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Post Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}