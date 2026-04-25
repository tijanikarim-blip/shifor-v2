import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../data/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel? user;
  const ProfileScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          Center(child: Column(children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              backgroundImage: user?.profileImageUrl != null ? CachedNetworkImageProvider(user!.profileImageUrl!) : null,
              child: user?.profileImageUrl == null ? Text((user?.name ?? 'D')[0].toString().toUpperCase(), style: const TextStyle(fontSize: 32, color: Colors.white)) : null,
            ),
            const SizedBox(height: 16),
            Text(user?.name ?? 'Driver', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)), child: Text((user?.role ?? 'DRIVER').toUpperCase(), style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600))),
          ])),
          const SizedBox(height: 32),
          _MenuItem(Icons.person_outline, 'Edit Profile', () {}),
          _MenuItem(Icons.settings_outlined, 'Settings', () {}),
          _MenuItem(Icons.help_outline, 'Help & Support', () {}),
          const Divider(height: 32),
          _MenuItem(Icons.logout, 'Logout', () {
            context.read<AuthProvider>().signOut();
            Navigator.of(context).pushNamedAndRemoveUntil('/sign-in', (route) => false);
          }, isDestructive: true),
        ]),
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