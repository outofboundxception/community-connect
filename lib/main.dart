import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/event_service.dart'; // 1. Make sure this is imported
import 'utils/app_theme.dart';

void main() {
  runApp(const FlutterConnectApp());
}

class FlutterConnectApp extends StatelessWidget {
  const FlutterConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MultiProvider to provide services to the widget tree
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(
          create: (_) => EventService(),
        ), // 2. Add EventService here
      ],
      child: MaterialApp(
        title: 'Flutter Connect',
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
