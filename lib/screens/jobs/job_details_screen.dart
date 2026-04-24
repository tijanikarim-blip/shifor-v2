import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../data/models/job_model.dart';
import '../../data/models/application_model.dart';
import '../../data/repositories/job_repository.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_constants.dart';

class JobDetailsScreen extends StatefulWidget {
  final JobModel job;

  const JobDetailsScreen({super.key, required this.job});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final _jobRepository = JobRepository();
  bool _isApplying = false;
  bool _hasApplied = false;

  @override
  void initState() {
    super.initState();
    _checkIfApplied();
  }

  Future<void> _checkIfApplied() async {
    final authProvider = context.read<AuthProvider>();
    if (!authProvider.isDriver) return;

    final applications = await _jobRepository.getApplications(
      driverId: authProvider.user!.uid,
      jobId: widget.job.id,
    );
    if (mounted) {
      setState(() => _hasApplied = applications.any((a) => a.jobId == widget.job.id));
    }
  }

  Future<void> _applyForJob() async {
    setState(() => _isApplying = true);
    try {
      final authProvider = context.read<AuthProvider>();
      final driver = authProvider.driverModel;

      if (driver == null) return;

      final application = ApplicationModel(
        id: '',
        jobId: widget.job.id,
        driverId: authProvider.user!.uid,
        companyId: widget.job.companyId,
        driverName: driver.fullName,
        driverPhotoUrl: driver.photoUrl,
        jobTitle: widget.job.title,
        companyName: widget.job.companyName,
        appliedAt: DateTime.now(),
      );

      await _jobRepository.applyForJob(application);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application submitted successfully')),
        );
        setState(() => _hasApplied = true);
      }
    } finally {
      setState(() => _isApplying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final authProvider = context.watch<AuthProvider>();
    final isDriver = authProvider.isDriver;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: job.companyLogoUrl != null
                              ? NetworkImage(job.companyLogoUrl!)
                              : null,
                          child: job.companyLogoUrl == null
                              ? const Icon(Icons.business, size: 30)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                job.companyName,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(
                      icon: Icons.work,
                      label: 'Job Type',
                      value: job.jobType,
                    ),
                    _DetailRow(
                      icon: Icons.location_on,
                      label: 'Location',
                      value: job.location ?? 'Not specified',
                    ),
                    _DetailRow(
                      icon: Icons.attach_money,
                      label: 'Salary',
                      value: '\$${job.salary?.toStringAsFixed(0) ?? '0'}/${job.salaryType}',
                    ),
                    _DetailRow(
                      icon: Icons.people,
                      label: 'Applications',
                      value: '${job.currentApplications}/${job.maxApplications}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              job.description ?? 'No description provided',
              style: TextStyle(color: Colors.grey.shade700, height: 1.5),
            ),
            if (job.requirements.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Requirements',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...job.requirements.map((req) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(req),
                  ],
                ),
              )),
            ],
            if (job.benefits.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Benefits',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...job.benefits.map((benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(benefit),
                  ],
                ),
              )),
            ],
            const SizedBox(height: 32),
            if (isDriver && !_hasApplied)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isApplying ? null : _applyForJob,
                  child: _isApplying
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Apply Now'),
                ),
              ),
            if (_hasApplied)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Already Applied'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}