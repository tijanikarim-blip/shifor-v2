import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_theme.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String _selectedCountry = 'All';
  final _countries = ['All', 'Morocco', 'France', 'Germany', 'UK', 'UAE', 'USA'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jobs'), actions: [IconButton(icon: const Icon(Icons.filter_list), onPressed: () {})]),
      body: Column(children: [
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _countries.length,
            itemBuilder: (context, index) {
              final country = _countries[index];
              final isSelected = country == _selectedCountry;
              return GestureDetector(
                onTap: () => setState(() => _selectedCountry = country),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: isSelected ? AppColors.primary : Colors.grey[100], borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text(country, style: TextStyle(color: isSelected ? Colors.white : Colors.grey[700], fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal))),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('jobs').where('isActive', isEqualTo: true).orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              final jobs = snapshot.data?.docs ?? [];
              if (jobs.isEmpty) return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.work_off, size: 64, color: Colors.grey), SizedBox(height: 16), Text('No jobs available', style: TextStyle(color: Colors.grey))]));
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index].data() as Map<String, dynamic>;
                  final jobId = jobs[index].id;
                  return _JobCard(title: job['title'] ?? '', company: job['companyName'] ?? '', salary: '\$${job['salary']?.toString() ?? '0'}/month', country: job['country'] ?? '', onTap: () => Navigator.of(context).pushNamed('/job-details', arguments: jobId));
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}

class _JobCard extends StatelessWidget {
  final String title;
  final String company;
  final String salary;
  final String country;
  final VoidCallback onTap;
  const _JobCard({required this.title, required this.company, required this.salary, required this.country, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.business, color: AppColors.primary)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), Text(company, style: TextStyle(color: Colors.grey[600]))])),
            Text(salary, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            _Chip(Icons.location_on, country),
          ]),
        ]),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(16)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 14, color: Colors.grey[600]), const SizedBox(width: 4), Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600]))]),
    );
  }
}