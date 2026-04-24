import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

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

  @override
  void dispose() {
    _titleController.dispose();
    _salaryController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Job')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Job Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _titleController,
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
                decoration: const InputDecoration(labelText: 'Job Title', prefixIcon: Icon(Icons.work)),
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField(
                value: _selectedCountry.isEmpty ? null : _selectedCountry,
                decoration: const InputDecoration(labelText: 'Country', prefixIcon: Icon(Icons.location_on)),
                items: AppConstants.countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedCountry = v ?? ''),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _salaryController,
                keyboardType: TextInputType.number,
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
                decoration: const InputDecoration(labelText: 'Monthly Salary (\$)', prefixIcon: Icon(Icons.monetization_on)),
              ),
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
              
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Description', alignLabelWithHint: true),
              ),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  const Text('Visa Sponsorship'),
                  const Spacer(),
                  Switch(value: false, onChanged: (v) {}),
                ],
              ),
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: () {},
                child: const Text('Post Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}