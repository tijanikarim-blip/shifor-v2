import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/job_repository.dart';
import 'data/repositories/application_repository.dart';
import 'services/auth_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/auth/verification_screen.dart';
import 'screens/auth/profile_completion_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/jobs/jobs_screen.dart';
import 'screens/jobs/job_details_screen.dart';
import 'screens/jobs/post_job_screen.dart';
import 'screens/applications/applications_screen.dart';
import 'screens/messages/messages_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase OK');
  } catch (e) {
    debugPrint('Firebase failed: $e');
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const ShiforApp());
}

class ShiforApp extends StatelessWidget {
  const ShiforApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        Provider(create: (_) => UserRepository()),
        Provider(create: (_) => JobRepository()),
        Provider(create: (_) => ApplicationRepository()),
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => LocationService()),
        Provider(create: (_) => StorageService()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/sign-in':
              return MaterialPageRoute(builder: (_) => const SignInScreen());
            case '/sign-up':
              return MaterialPageRoute(builder: (_) => const SignUpScreen());
            case '/verification':
              return MaterialPageRoute(builder: (_) => const VerificationScreen());
            case '/profile-completion':
              return MaterialPageRoute(builder: (_) => const ProfileCompletionScreen());
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomeScreen());
            default:
              return MaterialPageRoute(builder: (_) => const SignInScreen());
          }
        },
      ),
    );
  }
}