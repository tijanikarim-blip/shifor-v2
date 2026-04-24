import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../data/models/user_model.dart';
import 'jobs/jobs_screen.dart';
import 'applications/applications_screen.dart';
import 'messages/messages_screen.dart';
import 'profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeContent(user: user),
          const JobsScreen(),
          const ApplicationsScreen(),
          const MessagesScreen(),
          ProfileScreen(user: user),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Applications'),
          BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final UserModel? user;
  const _HomeContent({this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Welcome back,', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  Text(user?.name ?? 'Driver', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ]),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.primary,
                  backgroundImage: user?.profileImageUrl != null ? NetworkImage(user!.profileImageUrl!) : null,
                  child: user?.profileImageUrl == null ? Text((user?.name ?? 'D')[0].toString().toUpperCase(), style: const TextStyle(color: Colors.white)) : null,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(children: [
              Expanded(child: _QuickActionCard(icon: Icons.search, title: 'Find Jobs', onTap: () {})),
              const SizedBox(width: 16),
              Expanded(child: _QuickActionCard(icon: Icons.description, title: 'My Applications', onTap: () {})),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _QuickActionCard(icon: Icons.drive_eta, title: 'Availability', onTap: () {})),
              const SizedBox(width: 16),
              Expanded(child: _QuickActionCard(icon: Icons.people, title: 'References', onTap: () {})),
            ]),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.amber[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amber[200]!)),
              child: Row(children: [
                const Icon(Icons.warning_amber, color: Colors.amber),
                const SizedBox(width: 12),
                const Expanded(child: Text('Complete your profile to unlock all features')),
                TextButton(onPressed: () {}, child: const Text('Complete')),
              ]),
            ),
            const SizedBox(height: 32),
            const Text('Recent Jobs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _RecentJobCard(title: 'Heavy Truck Driver', company: 'Logistics Co', salary: '\$3,000/month', location: 'Germany'),
            _RecentJobCard(title: 'Bus Driver', company: 'Transit Agency', salary: '\$2,500/month', location: 'France'),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _QuickActionCard({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
        child: Column(children: [Icon(icon, size: 28, color: AppColors.primary), const SizedBox(height: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.w500))]),
      ),
    );
  }
}

class _RecentJobCard extends StatelessWidget {
  final String title;
  final String company;
  final String salary;
  final String location;
  const _RecentJobCard({required this.title, required this.company, required this.salary, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(company, style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.location_on, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Text(location, style: TextStyle(color: Colors.grey[600])),
          const Spacer(),
          Text(salary, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
        ]),
      ]),
    );
  }
}