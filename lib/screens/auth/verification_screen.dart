import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/theme/app_theme.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _emailOtpController = TextEditingController();
  final _phoneOtpController = TextEditingController();
  bool _emailSent = false;
  bool _phoneSent = false;

  @override
  void dispose() {
    _emailOtpController.dispose();
    _phoneOtpController.dispose();
    super.dispose();
  }

  Future<void> _sendEmailVerification() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.sendVerificationEmail();
    
    setState(() => _emailSent = true);
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification email sent! Check your inbox.')),
    );
  }

  Future<void> _verifyEmail() async {
    // In production, verify OTP via Firebase
    if (_emailOtpController.text.length == 6) {
      Navigator.of(context).pushReplacementNamed('/profile-completion');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verification')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.verified_user, size: 80, color: AppColors.primary),
              const SizedBox(height: 24),
              const Text(
                'Verify Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Complete verification to use the app',
                style: TextStyle(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Email Verification
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.email, color: AppColors.primary),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Email Verification',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (_emailSent)
                          const Icon(Icons.check_circle, color: AppColors.success),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (!_emailSent)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _sendEmailVerification,
                          child: const Text('Send Verification Email'),
                        ),
                      )
                    else
                      Column(
                        children: [
                          TextFormField(
                            controller: _emailOtpController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration: const InputDecoration(
                              labelText: 'Enter 6-digit code',
                              counterText: '',
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _verifyEmail,
                              child: const Text('Verify'),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Phone Verification
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.phone, color: AppColors.primary),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Phone Verification',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Phone verification coming soon',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () => Navigator.of(context).pushReplacementNamed('/profile-completion'),
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}