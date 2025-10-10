// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard/main_navigator.dart'; // Your app's home screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await FirebaseAppCheck.instance.activate(
    // Use the debug provider for testing
    androidProvider: AndroidProvider.debug,
    // You can also add appleProvider for iOS testing
  );

  if (kDebugMode) {
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );
}

  runApp(
    ChangeNotifierProvider<IAuthService>(
      create: (_) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer widget rebuilds when auth state changes
    return Consumer<IAuthService>(
      builder: (_, authService, __) {
        return MaterialApp(
          title: 'Community Connect',
          theme: ThemeData(primarySwatch: Colors.orange),
          // This is the "auth gate"
          home: authService.isAuthenticated 
              ? const MainNavigator() // If logged in, show home
              : const LoginScreen(), // If not, show login
        );
      },
    );
  }
}