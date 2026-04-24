import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class JobDetailsScreen extends StatelessWidget {
  final String jobId;
  const JobDetailsScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Details')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('jobs').doc(jobId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Job not found'));
          }
          
          final job = snapshot.data!.data() as Map<String, dynamic>;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.business, size: 32, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(job['title'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(job['companyName'] ?? '', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                _DetailRow(Icons.location_on, 'Location', job['country'] ?? ''),
                _DetailRow(Icons.directions_car, 'Vehicle', job['vehicleType'] ?? ''),
                _DetailRow(Icons.schedule, 'Contract', job['contractDuration'] ?? ''),
                _DetailRow(Icons.monetization_on, 'Salary', '\$${job['salary']}/month'),
                _DetailRow(Icons.flight, 'Visa Sponsorship', job['visaSponsorship'] == true ? 'Yes' : 'No'),
                
                const SizedBox(height: 24),
                const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(job['description'] ?? 'No description provided', style: TextStyle(color: Colors.grey[700], height: 1.5)),
                
                if (job['requirements'] != null && (job['requirements'] as List).isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text('Requirements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...(job['requirements'] as List).map((req) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, size: 20, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(child: Text(req)),
                      ],
                    ),
                  )),
                ],
                
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _apply(context),
                    child: const Text('Apply Now'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _apply(BuildContext context) async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    
    try {
      await FirebaseFirestore.instance.collection('applications').add({
        'jobId': jobId,
        'driverId': user.id,
        'driverName': user.name,
        'driverPhotoUrl': user.profileImageUrl,
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
      });
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application submitted!'), backgroundColor: AppColors.success),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: Colors.grey[600])),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}