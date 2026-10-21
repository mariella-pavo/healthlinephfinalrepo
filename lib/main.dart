
import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/dashboard.dart';
import 'screens/appointments.dart';
import 'screens/messages.dart';
import 'screens/profileandsettings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HealthLineApp());
}

class HealthLineApp extends StatelessWidget {
  const HealthLineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthLine PH',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/appointments': (context) => const AppointmentsScreen(),
        '/messages': (context) => const MessagesScreen(),
        '/profile-settings': (context) => const ProfileSettingsScreen(),
      },
    );
  }
}
